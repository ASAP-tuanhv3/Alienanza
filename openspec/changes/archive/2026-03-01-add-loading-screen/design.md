## Context

The project uses Nevermore's ServiceBag for dependency injection and Blend for declarative UI. Currently, `ClientMain.client.lua` creates a ServiceBag, registers services, and calls Init/Start in one shot with no loading feedback. Players see the default Roblox grey loading screen until the game renders.

The loading screen must show before ServiceBag is ready, yet integrate with ServiceBag-managed services (PlayerDataClient) for readiness checks. This creates a two-phase design: early display (pre-ServiceBag) and orchestrated dismissal (post-ServiceBag).

## Goals / Non-Goals

**Goals:**
- Display a branded loading screen immediately on join
- Provide per-phase status text so players know what's happening
- Fade out smoothly once all systems are ready (data + character)
- Follow Nevermore patterns (Blend UI, ServiceBag service, Maid cleanup)

**Non-Goals:**
- Asset preload progress bar (ContentProviderUtils only provides promise resolution, not incremental progress — would require custom wrapping of `ContentProvider:PreloadAsync` callbacks)
- Retry/timeout logic for failed data loads
- Animated splash art or branding beyond text + spinner
- Server-side loading coordination

## Decisions

### 1. Two-phase architecture: early show + service-driven dismiss

The loading screen ScreenGui is created directly in `ClientMain.client.lua` before ServiceBag initialization. This ensures it's visible immediately. The `LoadingScreenServiceClient` then takes ownership of the existing GUI to update status text and orchestrate dismissal.

**Why not create it entirely in the service?** ServiceBag Init/Start takes time — players would see nothing during that window. By creating the GUI upfront and passing it to the service, we get instant display with no gap.

**Flow:**
```
ClientMain.client.lua:
  1. Create LoadingScreenPane (shows immediately)
  2. Update status: "Loading game..."
  3. game:IsLoaded() or game.Loaded:Wait()
  4. Update status: "Starting services..."
  5. ServiceBag.new() → Init() → Start()
  6. Get LoadingScreenServiceClient from ServiceBag
  7. Service takes over: waits for player data + character
  8. Update status per phase
  9. Fade out + destroy
```

### 2. UI panes live in `src/modules/Client/UI/`

All UI pane classes go in a dedicated `UI/` folder under Client, keeping visual components separate from services and binders. This scales as more screens are added (e.g., HUD, menus). `LoadingScreenPane.lua` lives at `src/modules/Client/UI/LoadingScreenPane.lua`.

### 3. LoadingScreenPane built with Blend

The pane extends `BasicPane` and uses `Blend.New` for declarative UI. A `_statusText` ValueObject drives the status label reactively. A `_visible` spring drives the fade-out animation.

**Why Blend over manual Instance creation?** Blend provides reactive bindings (status text auto-updates when ValueObject changes) and spring animations natively. It's the Nevermore-standard approach for UI.

### 4. ScreenGui created at high DisplayOrder without GenericScreenGuiProvider

The loading screen needs to display before ServiceBag is initialized, so we can't use GenericScreenGuiProvider (which is a service). Instead, we manually create a ScreenGui with `DisplayOrder = 1000` and `IgnoreGuiInset = true` in PlayerGui. This is cleaned up on fade-out.

**Alternative considered:** Using `ReplicatedFirst` for the loading screen script. Rejected because it would be outside the Nevermore module system, making it harder to integrate with ServiceBag services for readiness checks.

### 5. Boot sequence in ClientMain drives status updates

Rather than having the service internally know about all boot phases, `ClientMain.client.lua` explicitly calls status update methods. This keeps the loading screen decoupled from specific services — it just shows what it's told.

```lua
-- ClientMain.client.lua (pseudocode)
local pane = LoadingScreenPane.new()
pane:Show()
pane:SetStatusText("Loading game...")
if not game:IsLoaded() then game.Loaded:Wait() end

pane:SetStatusText("Starting services...")
local serviceBag = ServiceBag.new()
serviceBag:GetService(require("TestQuentyServiceClient"))
serviceBag:Init()
serviceBag:Start()

pane:SetStatusText("Waiting for player data...")
-- wait for PlayerDataClient data

pane:SetStatusText("Spawning character...")
-- wait for character

pane:SetStatusText("Finishing up...")
pane:Hide() -- triggers spring fade-out
-- wait for animation, then destroy
```

### 6. PlayerDataClient readiness via ObserveData

Use `PlayerDataClient:ObserveData()` with Rx to detect when player data is non-nil. Convert to a promise using `RxUtils.promiseFirst` or similar pattern so the boot sequence can yield on it.

### 7. Character readiness via Players.LocalPlayer

Use `CharacterPromiseUtils.promiseCharacter(localPlayer)` from `@quenty/characterutils` to wait for character spawn.

## Risks / Trade-offs

- **[Risk] Loading screen created before ServiceBag** → We manually create ScreenGui and pane outside the normal service lifecycle. Mitigation: The pane is self-contained with its own Maid; cleanup happens on fade-out completion regardless of ServiceBag state.

- **[Risk] Race condition if data/character arrive before service starts** → The boot sequence checks each condition inline (e.g., `if PlayerDataClient:GetData() then skip`). Mitigation: Each wait step is a simple "already done?" check before yielding.

- **[Trade-off] No incremental asset preload progress** → ContentProviderUtils returns a single promise, not progress callbacks. Adding progress would require directly wrapping `ContentProvider:PreloadAsync` with a callback. Accepted for v1 — status text is sufficient feedback.

- **[Trade-off] ScreenGui not managed by GenericScreenGuiProvider** → Loading screen exists before ServiceBag. Acceptable since it's temporary and destroyed after boot.
