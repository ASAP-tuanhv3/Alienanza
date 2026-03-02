# First Playable — Test Arena + Character Controller

## Summary

Build the minimum slice needed to prove OOB Odyssey is fun: a test arena made from Kenney assets (scaled 0.1x) and a modified-humanoid character controller with platformer feel (coyote time, air control, variable jump). This is the foundation everything else builds on.

## Motivation

The GDD identifies character controller as the #1 development priority. Before building kingdoms, we need to validate that movement feels great on these assets. A small test arena gives us a playground to iterate on feel.

## Scope

### In Scope

1. **Test Arena** — Built via MCP `run_code`, placed directly in Workspace
   - Spawn platform (large flat grass area)
   - Coin path (straight run with bronze coins)
   - Slope section (ramp up to higher ground)
   - Gap jump (test basic jumping distance)
   - Stepping platforms (vertical jumps at increasing heights)
   - Crate area (one crate to break later with hat throw)
   - End platform with a star

2. **Character Controller** (client-side, modified humanoid)
   - Walk speed: 24 studs/s, Run speed: 36 studs/s (hold shift)
   - Jump height: 12 studs (variable — hold space for full height)
   - Air control: 60% of ground speed
   - Coyote time: 0.15s (can jump briefly after leaving edge)
   - Third-person camera: 15 studs behind, 8 studs above, 0.2s lerp

3. **Coin Collection** (basic)
   - Touch coin to collect, coin disappears
   - Simple BillboardGui counter above player or ScreenGui
   - Sound on collect

### Out of Scope (deferred)

- Hat throw mechanic (next change)
- Checkpoints / respawn
- Star collection logic
- Character rescue
- Full Kingdom 1 layout
- Backflip, wall slide, wall jump
- Enemies / hazards (saws, spikes, bombs)

## Nevermore Packages

### Already Installed (will use)

| Package | Purpose |
|---------|---------|
| `@quenty/baseobject` | Base class for controller, coin collector |
| `@quenty/maid` | Cleanup management |
| `@quenty/servicebag` | Service registration |
| `@quenty/binder` | Tag-based coin behavior |
| `@quenty/characterutils` | Character/humanoid access |
| `@quenty/humanoidtracker` | Track humanoid state changes |
| `@quenty/steputils` | RunService frame stepping for controller |
| `@quenty/valueobject` | Observable coin count |
| `@quenty/signal` | Custom events |
| `@quenty/sounds` | Coin collect sound |
| `@quenty/soundplayer` | Sound playback |

### Need to Install

| Package | Purpose |
|---------|---------|
| `@quenty/camera` | CameraStack for third-person follow camera |
| `@quenty/templateprovider` | Asset template management (clone from ReplicatedStorage) |
| `@quenty/rogue-humanoid` | Humanoid property management (speed, jump) |
| `@quenty/inputkeymaputils` | Input binding for sprint |

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     SERVER                                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  TestQuentyService (entry point)                            │
│  ├── ArenaService          Build test arena in Workspace     │
│  └── CoinService           Server-side coin state + binder  │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                     CLIENT                                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  TestQuentyServiceClient (entry point)                      │
│  ├── CharacterControllerClient   Modified humanoid movement │
│  ├── CoinServiceClient           Coin collection + HUD      │
│  └── GameCameraServiceClient     Third-person camera        │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                     SHARED                                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ArenaConstants          Asset scale, layout data            │
│  CoinConstants           Coin values, collect radius         │
│  MovementConstants       Speeds, jump height, coyote time    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Asset Scale Strategy

All Kenney assets are scaled 0.1x when placed. Reference sizes at 0.1x:

| Asset | Original Size | At 0.1x | Feels Like |
|-------|--------------|---------|------------|
| block-grass | 108 x 100 x 108 | 10.8 x 10 x 10.8 | Standard platform (2x player height) |
| block-grass-narrow | 78 x 100 x 78 | 7.8 x 10 x 7.8 | Tight ledge |
| block-grass-large | 208 x 100 x 208 | 20.8 x 10 x 20.8 | Wide platform |
| block-grass-low | (low variant) | ~10.8 x 5 x 10.8 | Half-height step |
| coin-bronze | 40 x 40 x 18 | 4 x 4 x 1.8 | Collectible (just under player height) |
| crate | 50 x 50 x 50 | 5 x 5 x 5 | Breakable box (player-sized) |
| star | 36 x 36 x 24 | 3.6 x 3.6 x 2.4 | Reward collectible |

Player jump height (12 studs) vs block height (10 studs) = can barely jump onto a block. This is the Mario feel.

## Test Arena Layout

```
                                    [narrow]  ← stepping platforms
                                   *  |
                              [narrow] *
                             *  |
                        [low] *           [grass]──★
                       *  |               end + star
                                     ?
  P───[large]───*─*─*───[grass]~~[slope]──[grass]───[grass]
  spawn          coins    flat    ramp up   gap     crate area

  Legend:
  P = spawn    * = coin    ~~ = slope    ? = crate    ★ = star
  [large] = block-grass-large (spawn platform)
  [grass] = block-grass (standard)
  [low] = block-grass-low (half height step)
  [narrow] = block-grass-narrow (tight platform)
```

## Risk Assessment

- **Humanoid modification limits**: Roblox humanoid doesn't natively support coyote time or variable jump. These require client-side state tracking on top of humanoid. Medium complexity.
- **Asset scale**: 0.1x might need fine-tuning. We should make scale a constant so it's easy to adjust.
- **Camera**: Nevermore's CameraStack is powerful but has a learning curve. May need to read source if docs are insufficient.
