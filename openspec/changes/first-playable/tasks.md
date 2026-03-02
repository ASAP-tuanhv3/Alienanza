# First Playable — Tasks

## Task 1: Install Dependencies

Install missing Nevermore packages and promote transitive deps to direct.

```bash
pnpm install @quenty/humanoidtracker @quenty/collectionserviceutils @quenty/templateprovider @quenty/steputils @quenty/signal @quenty/brio
```

Verify all packages resolve and `node_modules/@quenty/` contains them.

---

## Task 2: Create Shared Constants

### 2a: MovementConstants

Create `src/modules/Shared/MovementConstants.lua`:

```lua
--!strict
--[=[ @class MovementConstants ]=]

local MovementConstants = {
    WALK_SPEED = 24,
    RUN_SPEED = 36,
    JUMP_HEIGHT = 12,
    AIR_CONTROL = 0.6,
    COYOTE_TIME = 0.15,
    VARIABLE_JUMP_CUT = 0.4,
}

return MovementConstants
```

### 2b: CoinConstants

Create `src/modules/Shared/CoinConstants.lua`:

```lua
--!strict
--[=[ @class CoinConstants ]=]

local CoinConstants = {
    TAG = "Coin",
    VALUES = {
        ["coin-bronze"] = 1,
        ["coin-silver"] = 5,
        ["coin-gold"] = 10,
    },
    DEFAULT_VALUE = 1,
    REMOTE_EVENT_NAME = "CoinCollected",
}

return CoinConstants
```

### 2c: Add CoinCollect sound to SoundConstants

Add a `CoinCollect` entry to `SoundConstants.Sounds` in `src/modules/Shared/SoundConstants.lua`.

---

## Task 3: Build Test Arena via MCP

Use `run_code` to place scaled assets in Workspace. All assets cloned from `ReplicatedStorage.Assets`, scaled 0.1x via `Model:ScaleTo(0.1)`.

### 3a: Place terrain blocks

Place all platform blocks per the design layout:
- Spawn platform (block-grass-large) at origin
- Coin path (2× block-grass-long)
- Pre-slope block (block-grass)
- Slope ramp (block-grass-large-slope)
- Slope top platform (block-grass)
- Gap landing (block-grass) — 12 stud gap from slope top
- Crate platform (block-grass)
- Stepping platforms (2× block-grass-low, 2× block-grass-narrow) branching right
- End platform (block-grass)

All blocks should be anchored. Place a SpawnLocation on the spawn platform.

### 3b: Place coins

Place bronze coins along coin path (6 coins, floating 3 studs above surface), silver coin on stepping platform step 3, gold coins on slope top and step 4 top.

All coins:
- Tag with "Coin" via `CollectionService:AddTag()`
- Set `Name` to match asset name (e.g., "coin-bronze") for value lookup
- Anchored, CanCollide = false

### 3c: Place decorations and objects

- 1 crate on the crate platform
- 1 star floating + spinning on end platform (use a simple rotation script or just place static for now)
- 1 flag at the pre-slope checkpoint
- A few trees/flowers on spawn platform for visual interest

### 3d: Add a baseplate/kill zone

Add a large invisible part below the arena (Y = -50) with a Touched event or use `Humanoid.StateChanged → Enum.HumanoidStateType.FallingDown` to respawn. For now, just add a flat baseplate at Y = -10 so falling players land somewhere.

---

## Task 4: Create CoinService (Server)

### 4a: Create Coin binder class

Create `src/modules/Server/Binders/Coin.lua`:

- Extends `BaseObject`
- Constructor: store instance reference, determine value from `CoinConstants.VALUES[instance.Name]`
- Connect `instance.Touched` → check `CharacterUtils.getPlayerFromCharacter(hit)`
- On valid player touch: mark collected, award coins via `PlayerDataService`, fire `CoinCollected` RemoteEvent to client, destroy instance
- Prevent double-collection with a `_collected` flag

### 4b: Create CoinService

Create `src/modules/Server/CoinService.lua`:

- Standard service template
- In `Init`: create Binder for "Coin" tag with `Coin` class, create RemoteEvent
- In `Start`: start the binder
- Expose `GetCoinBinder()` method

### 4c: Register CoinService

Add `self._serviceBag:GetService(require("CoinService"))` to `TestQuentyService.Init`.

---

## Task 5: Create CoinServiceClient (Client)

### 5a: Create CoinServiceClient

Create `src/modules/Client/CoinServiceClient.lua`:

- Standard client service template
- In `Init`: get dependencies (SoundServiceClient, Remoting)
- In `Start`: listen for `CoinCollected` RemoteEvent
- On receive: play coin collect sound, spawn gold particle burst at position

### 5b: Create CoinHudClient

Create `src/modules/Client/UI/CoinHudClient.lua`:

- Client service that creates a ScreenGui with coin count display
- Simple TextLabel: coin icon (ImageLabel) + count (TextLabel)
- Position: top-left corner
- Updates when `CoinCollected` fires (read `totalCoins` from payload)
- Use Blend for reactive UI or plain Instance creation

### 5c: Register client services

Add both services to `TestQuentyServiceClient.Init`.

---

## Task 6: Create CharacterControllerClient

Create `src/modules/Client/CharacterControllerClient.lua`:

### 6a: Base humanoid modification

- On character spawn: set `Humanoid.WalkSpeed`, `Humanoid.JumpHeight`, `Humanoid.UseJumpPower = false`
- Use `Players.LocalPlayer.CharacterAdded` + handle existing character

### 6b: Sprint (shift to run)

- Listen to `UserInputService.InputBegan`/`InputEnded` for `Enum.KeyCode.LeftShift`
- On hold: `Humanoid.WalkSpeed = RUN_SPEED`
- On release: `Humanoid.WalkSpeed = WALK_SPEED`
- Track `isSprinting` state for air control calculation

### 6c: Coyote time

- Track grounded state via `Humanoid.StateChanged`
- When entering `Freefall` without jumping: record `leftGroundTime = tick()`
- On `Humanoid.JumpRequest` (or `UserInputService` space press): allow jump if within `COYOTE_TIME` window
- Reset on landing

### 6d: Variable jump height

- On `RenderStepped` while airborne: if jump key released and vertical velocity > 0, multiply Y velocity by `VARIABLE_JUMP_CUT`
- Only apply once per jump

### 6e: Air control

- When airborne: `Humanoid.WalkSpeed = baseSpeed * AIR_CONTROL`
- When grounded: restore full `WalkSpeed`

### 6f: Register service

Add to `TestQuentyServiceClient.Init`.

---

## Task 7: Create GameCameraClient

Create `src/modules/Client/GameCameraClient.lua`:

### 7a: Camera setup

- On character spawn: lock camera zoom distance, set CameraOffset
- `player.CameraMinZoomDistance = 15`
- `player.CameraMaxZoomDistance = 15`
- `humanoid.CameraOffset = Vector3.new(0, 3, 0)`
- Set `camera.CameraType = Enum.CameraType.Custom` (default follow behavior)

### 7b: Register service

Add to `TestQuentyServiceClient.Init`.

---

## Unit Tests

### Test 8a: MovementConstants.spec.lua

Create `src/modules/Shared/MovementConstants.spec.lua`:

- Test that all expected keys exist and have number values
- Test that WALK_SPEED < RUN_SPEED
- Test that COYOTE_TIME > 0 and < 1
- Test that AIR_CONTROL is between 0 and 1

### Test 8b: CoinConstants.spec.lua

Create `src/modules/Shared/CoinConstants.spec.lua`:

- Test that TAG is a string
- Test that VALUES table has entries for coin-bronze, coin-silver, coin-gold
- Test that values are in ascending order (bronze < silver < gold)
- Test that DEFAULT_VALUE is a number

### Test 8c: Coin.spec.lua

Create `src/modules/Server/Binders/Coin.spec.lua`:

- Test that Coin module loads successfully
- Test constructor expectations (requires server context — use pcall guard)

### Test 8d: CoinService.spec.lua

Create `src/modules/Server/CoinService.spec.lua`:

- Test that module loads
- Test ServiceName is set

### Test 8e: CharacterControllerClient.spec.lua

Create `src/modules/Client/CharacterControllerClient.spec.lua`:

- Use pcall guard for client module
- Test module loads (or gracefully skips in server context)

### Test 8f: CoinServiceClient.spec.lua

Create `src/modules/Client/CoinServiceClient.spec.lua`:

- Use pcall guard for client module
- Test module loads

---

## MCP Validation

### Validation 9a: Run all unit tests

Execute via `run_script_in_play_mode` with `run_server` mode:

```lua
local SSS = game:GetService("ServerScriptService")
local TestQuenty = SSS.TestQuenty
local TestEZ = require(TestQuenty.game.Shared.TestEZ)
local TestBootstrap = TestEZ.TestBootstrap

local results = TestBootstrap:run({
    TestQuenty.game.Shared,
    TestQuenty.game.Server,
    TestQuenty.game.Client,
})

print(results:visualize())
print("Success: " .. results.successCount .. ", Failures: " .. results.failureCount)
```

All tests must pass. Fix any failures before proceeding.

### Validation 9b: Verify arena loads in play mode

Use `start_stop_play` with `start_play` to enter play mode. Then `get_console_output` to check for errors. Verify:
- No Lua errors in console
- Player spawns on the arena
- Coins are visible and tagged

### Validation 9c: Test coin collection in play mode

Use `run_script_in_play_mode` with `start_play` mode to verify:
- Player character exists
- Coins have "Coin" tag
- Touch a coin programmatically and verify it disappears

---

## Final Review

- [x] All unit tests pass (Validation 9a)
- [x] Arena loads without errors (Validation 9b)
- [ ] Coin collection works (Validation 9c)
- [ ] Character controller feels responsive (manual play test)
- [ ] Camera follows player at correct distance
- [ ] Sprint works (shift to run)
- [ ] Coyote time allows edge jumps
- [ ] Variable jump height works (tap vs hold)
- [x] No linting errors (`npm run lint:selene`, `npm run lint:stylua`)
- [x] All new files follow Nevermore conventions (--!strict, Moonwave docstrings, loader require, PascalCase)
