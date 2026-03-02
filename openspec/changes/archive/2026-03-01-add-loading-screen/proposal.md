## Why

Players see Roblox's default grey loading state while the game boots. A custom loading screen replaces this with branded visuals and status feedback. Beyond cosmetics, it also orchestrates the full client boot sequence — ensuring game content, player data, and character are all ready before handing control to the player.

## What Changes

- Add a loading screen that displays immediately on join, replacing the default Roblox loading screen (`ReplicatedFirst:RemoveDefaultLoadingScreen()`)
- Show dynamic status text reflecting each boot phase: "Loading game...", "Waiting for player data...", "Spawning character..."
- Show a progress indicator during asset preloading
- Orchestrate the boot sequence: game content load → ServiceBag init/start → wait for player data → wait for character spawn → fade out
- Modify `ClientMain.client.lua` to integrate the loading screen into the boot flow
- Add a `LoadingScreenServiceClient` that coordinates readiness signals from other services
- Build the UI declaratively with Blend

## Capabilities

### New Capabilities
- `loading-screen`: Client-side loading screen with boot-sequence orchestration, status text updates per phase, asset preload progress, and fade-out transition when all systems are ready (game loaded, player data received, character spawned)

### Modified Capabilities
<!-- None — this is a new standalone feature -->

## Impact

- **New files**: `LoadingScreenServiceClient.lua` in `src/modules/Client/`, `LoadingScreenPane.lua` (+ spec files) in `src/modules/Client/UI/`
- **Modified files**: `ClientMain.client.lua` (integrate loading screen into boot sequence), `TestQuentyServiceClient.lua` (register `LoadingScreenServiceClient`)
- **Dependencies**: Requires installing `@quenty/blend`, `@quenty/basicpane`, `@quenty/genericscreenguiprovider`, `@quenty/contentproviderutils`, `@quenty/spring`, `@quenty/characterutils`
- **Already installed**: `@quenty/maid`, `@quenty/servicebag`, `@quenty/valueobject`, `@quenty/rx`

## Nevermore Packages

| Package | Relevance |
|---------|-----------|
| `@quenty/blend` | Declarative reactive UI framework for building the loading screen |
| `@quenty/basicpane` | Base pane class with show/hide lifecycle |
| `@quenty/genericscreenguiprovider` | Provides ScreenGui at correct display order |
| `@quenty/contentproviderutils` | Wraps `ContentProvider:PreloadAsync` with progress tracking |
| `@quenty/spring` | Smooth spring-based fade-out animation |
| `@quenty/characterutils` | `CharacterPromiseUtils` for waiting on character spawn |
