# First Playable — Design

## Overview

Build a test arena from scaled Kenney assets and a modified-humanoid character controller. The arena is built via MCP `run_code` (placed directly in Workspace). The character controller modifies the default Roblox Humanoid with custom client-side logic for platformer feel.

## Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                        SERVER                                 │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  TestQuentyService (existing entry point)                    │
│  ├── CoinService        Server-side coin binder + collection │
│  │   └── CoinBinder     Binder for "Coin" tagged instances   │
│  └── (ArenaService)     NOT a code service — built via MCP   │
│                                                               │
├──────────────────────────────────────────────────────────────┤
│                        CLIENT                                 │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  TestQuentyServiceClient (existing entry point)              │
│  ├── CharacterControllerClient  Platformer movement mods     │
│  ├── CoinServiceClient          Client coin feedback + HUD   │
│  └── GameCameraClient           Third-person follow camera   │
│                                                               │
├──────────────────────────────────────────────────────────────┤
│                        SHARED                                 │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  MovementConstants      Speed, jump, coyote time values      │
│  CoinConstants          Coin tag, values, collect radius     │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

### Decision: No ArenaService in Code

The test arena is built once via MCP `run_code` and saved to the place file. There's no runtime level-building service for the first playable. This avoids complexity — we can add procedural spawning later when we build Kingdom 1.

### Decision: Coins as Server-Side Binder

Coins are CollectionService-tagged instances ("Coin") managed by a server Binder. When a player touches a coin, the server validates and awards the coin. The client shows particle/sound feedback. This prevents exploits (client can't fake coin collection).

### Decision: Camera — Simple Custom (No @quenty/camera Yet)

After reviewing CameraStackService, it's powerful but overkill for a basic third-person follow camera. We'll write a simple client camera script using RunService.RenderStepped directly. We can migrate to CameraStack later when we need camera zones, shake effects, etc.

### Decision: No @quenty/rogue-humanoid

RogueHumanoid provides modifier stacking (multipliers, additives) on humanoid properties. For the first playable we only need to set fixed values (WalkSpeed, JumpHeight). We'll set these directly on the Humanoid and add RogueHumanoid later when character rescue abilities need stacking modifiers.

## Module Designs

### MovementConstants (Shared)

```lua
MovementConstants = {
    WALK_SPEED = 24,           -- studs/s
    RUN_SPEED = 36,            -- studs/s (hold shift)
    JUMP_HEIGHT = 12,          -- studs
    AIR_CONTROL = 0.6,         -- 60% of ground speed
    COYOTE_TIME = 0.15,        -- seconds after leaving edge
    CAMERA_DISTANCE = 15,      -- studs behind player
    CAMERA_HEIGHT = 8,         -- studs above player
    CAMERA_LERP = 0.2,         -- seconds smoothing
}
```

Plain constant table. No loader needed. No dependencies.

### CoinConstants (Shared)

```lua
CoinConstants = {
    TAG = "Coin",
    VALUES = {
        Bronze = 1,
        Silver = 5,
        Gold = 10,
    },
    COLLECT_RADIUS = 5,        -- studs (for future magnet)
    RESPAWN_TIME = 0,          -- 0 = no respawn in first playable
}
```

### CharacterControllerClient (Client Service)

**Purpose:** Modifies the default Humanoid to feel like a platformer.

**Dependencies:**
- `CharacterUtils` — get humanoid from local player
- `Maid` — cleanup per-character connections
- `RunService` — frame updates for coyote time, air control

**Lifecycle:**
1. `Init`: store serviceBag, get dependencies
2. `Start`: observe player character spawns, apply modifications per humanoid

**Per-Humanoid Setup:**
- Set `Humanoid.WalkSpeed` = `MovementConstants.WALK_SPEED`
- Set `Humanoid.UseJumpPower` = false, `Humanoid.JumpHeight` = `MovementConstants.JUMP_HEIGHT`
- Track `Humanoid.FloorMaterial` to detect grounded vs airborne
- Track `Humanoid.StateChanged` for jump/freefall states

**Coyote Time Implementation:**
```
State tracking:
  wasGrounded: boolean
  leftGroundTime: number (tick())
  hasJumped: boolean

On StateChanged → Freefall:
  if not hasJumped then
    wasGrounded = true
    leftGroundTime = tick()

On jump input (UserInputService.JumpRequest):
  if grounded OR (wasGrounded AND tick() - leftGroundTime < COYOTE_TIME) then
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    hasJumped = true

On StateChanged → Landed:
  wasGrounded = false
  hasJumped = false
```

**Variable Jump Height:**
```
On JumpRequest:
  apply full jump velocity

On RenderStepped (while airborne):
  if jump button released AND rootPart.AssemblyLinearVelocity.Y > 0 then
    -- Cut vertical velocity to 40% for a short hop
    rootPart.AssemblyLinearVelocity *= Vector3.new(1, 0.4, 1)
```

**Sprint:**
```
On shift held: Humanoid.WalkSpeed = RUN_SPEED
On shift released: Humanoid.WalkSpeed = WALK_SPEED
```

**Air Control:**
Not directly controllable via Humanoid API. Instead, we reduce WalkSpeed while airborne:
```
On Freefall: Humanoid.WalkSpeed = currentSpeed * AIR_CONTROL
On Landed: Humanoid.WalkSpeed = currentSpeed (full)
```

### GameCameraClient (Client Service)

**Purpose:** Third-person camera that follows the player.

**Dependencies:**
- `RunService` — RenderStepped for camera update
- `Maid` — cleanup

**Implementation:**
- On `Start`, bind to `RenderStepped` at `Enum.RenderPriority.Camera.Value + 1`
- Each frame:
  1. Get player character root part position
  2. Get current camera CFrame from Roblox's default camera
  3. Override only the distance/height: offset the camera to be `CAMERA_DISTANCE` behind and `CAMERA_HEIGHT` above the character
  4. Lerp smoothly using `CAMERA_LERP`

**Decision:** We keep Roblox's default camera rotation (mouse-look) and only modify the follow distance/height. This gives us free mouse rotation without reimplementing it.

```lua
-- Pseudocode for camera update
local targetOffset = CFrame.new(0, CAMERA_HEIGHT, CAMERA_DISTANCE)
local rootCF = rootPart.CFrame
local desiredCF = rootCF * targetOffset
camera.CFrame = camera.CFrame:Lerp(desiredCF, dt / CAMERA_LERP)
```

Actually, the simpler approach: just set `player.CameraMinZoomDistance` and `player.CameraMaxZoomDistance` to lock zoom, and adjust `Humanoid.CameraOffset` for the height. The default Roblox follow camera already handles rotation and follow. We just constrain it.

```lua
player.CameraMinZoomDistance = 15
player.CameraMaxZoomDistance = 15
humanoid.CameraOffset = Vector3.new(0, 3, 0)  -- slightly above head
```

This is dramatically simpler and gives us 90% of what we need. We can replace with a full custom camera later.

### CoinService (Server Service)

**Purpose:** Manage coin instances via Binder. Handle collection on touch.

**Dependencies:**
- `Binder` — bind "Coin" tagged instances
- `Maid` — cleanup
- `CharacterUtils` — identify player from touch
- `PlayerDataService` — award coins to player data

**Binder Class: `Coin`**

Extends `BaseObject`. Constructor receives the coin instance.

```
Coin.new(instance):
  self._instance = instance
  self._value = determine value from instance.Name or attribute

  Connect instance.Touched → onTouched

Coin:onTouched(hit):
  player = CharacterUtils.getPlayerFromCharacter(hit)
  if player and not self._collected then
    self._collected = true
    -- Award coins via PlayerDataService
    -- Fire remote to client for feedback
    self._instance:Destroy()
```

**Remoting:** Fire a RemoteEvent `CoinCollected` to the collecting player's client with the coin value and position (for particle spawn location).

### CoinServiceClient (Client Service)

**Purpose:** Listen for `CoinCollected` remote, play sound + particle.

**Dependencies:**
- `SoundServiceClient` — play coin collect sound
- `Maid` — cleanup

**On CoinCollected(value, position):**
1. Play coin sound (ascending pitch for combos — track last collect time)
2. Spawn particle burst at position (simple gold ParticleEmitter, 0.3s lifetime)
3. Update HUD coin counter

**HUD:** Simple ScreenGui with a TextLabel showing coin count. Uses Blend (already installed) for reactive UI, or a plain ScreenGui for simplicity.

## Test Arena — Asset Placement

### Scale Factor

All assets cloned from `ReplicatedStorage.Assets` and scaled by `0.1` using `Model:ScaleTo()` (Roblox API for uniform model scaling).

### Block Sizes at 0.1x (Reference)

| Asset | Scaled Size (X × Y × Z) | Role |
|-------|-------------------------|------|
| block-grass-large | 20.8 × 10.0 × 20.8 | Spawn platform |
| block-grass | 10.8 × 10.0 × 10.8 | Standard platform |
| block-grass-narrow | 7.8 × 10.0 × 7.8 | Tight platform |
| block-grass-low | 10.8 × 5.0 × 10.8 | Half-height step |
| block-grass-low-large | 20.8 × 5.0 × 20.8 | Low wide platform |
| block-grass-large-slope | 20.8 × 7.6 × 20.1 | Gentle ramp |
| block-grass-long | 20.8 × 10.0 × 10.8 | Bridge |
| coin-bronze | 4.0 × 4.0 × 1.8 | Collectible |
| crate | 5.0 × 5.0 × 5.0 | Breakable box |
| star | 3.6 × 3.6 × 2.4 | Reward |
| flag | 4.2 × 9.0 × 1.1 | Checkpoint (visual only) |

### Arena Layout (Detailed)

```
                                      Z- (forward)
                                          ↑
                                          |
                                          |

   Section 6: End Platform               Section 5: Stepping Platforms
   ┌──────────┐                           [narrow] Y=25
   │ grass +  │                              ↑
   │   ★      │ Y=10                    [narrow] Y=20
   └──────────┘                              ↑
        ↑                               [low] Y=15
        |                                    ↑
   Section 4b: Landing                  [low] Y=10
   ┌──────────┐                         (branching from Section 3)
   │  grass   │ Y=10
   └──────────┘
        ↑
     ...gap... (12 studs)
        ↑
   Section 3: Slope Top
   ┌────────────────────┐
   │  grass + slope     │ Y=5→10
   └────────────────────┘
        ↑
   Section 2: Coin Path
   ┌──────────────────────────────────┐
   │  long + long  (coins floating)  │ Y=0
   └──────────────────────────────────┘
        ↑
   Section 1: Spawn
   ┌────────────────────┐
   │  large (spawn)     │ Y=0
   │        P           │
   └────────────────────┘

X- ←───────────────────────────→ X+
```

### Placement Coordinates

All positions are the **center** of the placed model, Y is the bottom surface.

| # | Asset | Position (X, Y, Z) | Notes |
|---|-------|-------------------|-------|
| 1 | block-grass-large | (0, 0, 0) | Spawn platform. SpawnLocation on top. |
| 2 | block-grass-long | (0, 0, -20) | Coin path segment 1. 3 bronze coins on top. |
| 3 | block-grass-long | (0, 0, -40) | Coin path segment 2. 3 bronze coins + 1 silver. |
| 4 | block-grass | (0, 0, -56) | Base before slope. |
| 5 | block-grass-large-slope | (0, 0, -72) | Ramp going up. Top surface ~Y=7.6. |
| 6 | block-grass | (0, 7.6, -90) | Top of slope. 1 gold coin. |
| 7 | block-grass | (0, 7.6, -112) | Landing after gap (12 stud gap). |
| 8 | block-grass | (0, 7.6, -128) | Crate platform. 1 crate on top. |
| 9 | block-grass-low | (15, 10, -90) | Step 1 (branching right from slope top). |
| 10 | block-grass-low | (15, 15, -80) | Step 2. |
| 11 | block-grass-narrow | (15, 20, -70) | Step 3. 1 silver coin. |
| 12 | block-grass-narrow | (15, 25, -60) | Step 4 (top). 1 gold coin. |
| 13 | block-grass | (0, 7.6, -145) | End platform. Star on top. |
| C1–C6 | coin-bronze | Along path segments | Floating 3 studs above surface. |
| C7 | coin-silver | On step 3 | Floating 3 studs above surface. |
| C8–C9 | coin-gold | Slope top + step 4 | Floating 3 studs above surface. |
| S1 | star | (0, 12, -145) | On end platform, floating + spinning. |
| CR1 | crate | (0, 13, -128) | On crate platform. |
| F1 | flag | (0, 10.5, -56) | Before slope (visual checkpoint). |

## Remoting Design

### CoinCollected (Server → Client)

```
RemoteEvent: "CoinCollected"
Payload: {
    value: number,      -- coin value (1, 5, 10)
    position: Vector3,  -- world position for particle effect
    totalCoins: number, -- updated total for HUD
}
```

Fired from CoinService to the specific player who collected the coin.

## Sound Design

Add entries to `SoundConstants`:

```lua
CoinCollect = {
    SoundId = "rbxassetid://6895079853",  -- placeholder, replace with coin sound
    Group = WellKnownSoundGroups.SFX,
    Volume = 0.5,
},
```

## Dependencies to Install

| Package | Why |
|---------|-----|
| `@quenty/humanoidtracker` | Track humanoid lifecycle per player |
| `@quenty/collectionserviceutils` | Needed by binder (ensure direct dep) |
| `@quenty/templateprovider` | Already transitive, make explicit |
| `@quenty/steputils` | Already transitive, make explicit |
| `@quenty/signal` | Already transitive, make explicit |
| `@quenty/brio` | Already transitive, make explicit |

**Removed from proposal** (not needed for first playable):
- `@quenty/camera` — using Humanoid.CameraOffset + zoom lock instead
- `@quenty/rogue-humanoid` — setting humanoid properties directly
- `@quenty/inputkeymaputils` — using UserInputService directly for sprint
