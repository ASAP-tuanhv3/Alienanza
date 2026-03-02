## Why

The game currently has a small test arena with scattered assets but no cohesive level design. A complete vertical climbing level will give players a full gameplay experience — starting at the bottom, navigating hazards, collecting coins, riding moving platforms, and reaching the summit to win. This leverages all existing functional systems (spikes, coins, moving platforms) and the full asset library.

## What Changes

- **Replace TestArena** with a complete, designed level map called "ClimbingLevel"
- **Build a multi-zone vertical level** with 5 distinct zones stacking upward:
  1. **Spawn Meadow** (ground level) — flat grass terrain with decorations, tutorial coins
  2. **Forest Gauntlet** — platforming with spike hazards, trees, and nature props
  3. **Moving Platform Canyon** — gaps bridged by all 3 moving platform variants
  4. **Snow Summit** — snow-themed blocks with steep slopes, narrow ledges, and spike traps
  5. **Victory Peak** — final platform with a star collectible and flag marking completion
- **Place coins throughout** as breadcrumbs guiding the player path (bronze → silver → gold progression)
- **Place spike hazards** at key chokepoints to add challenge
- **Configure moving platforms** with waypoints to bridge gaps between sections
- **Decorate with props** — trees, flowers, grass, mushrooms, rocks, fences, crates, hedges across all zones
- **Add a win detection system** that triggers when the player reaches the Victory Peak star

## Capabilities

### New Capabilities
- `level-layout`: Complete level geometry layout built from asset blocks — zone definitions, block placement coordinates, and spatial design for the full climbing level
- `win-condition`: Detection system that triggers when the player collects the summit star or reaches the victory platform, displaying a congratulations message

### Modified Capabilities
- None

## Impact

- **Workspace**: TestArena folder replaced with ClimbingLevel folder containing all level geometry
- **Server**: New `WinConditionService` to detect level completion
- **Client**: New `WinConditionServiceClient` to display victory UI
- **Assets used**: All block-grass, block-snow, block-moving variants; all collectibles; hazard spike-blocks; nature props; fences; containers; flags
- **Existing systems**: Leverages existing MovingPlatform, SpikeBlock, and Coin binders — no changes needed to those specs

## Nevermore Packages

Existing packages already in use cover the needs:
- `@quenty/binder` — for win-condition detection binder
- `@quenty/servicebag` — service registration
- `@quenty/baseobject` — base class for binders
- `@quenty/maid` — cleanup
- `@quenty/remoting` — server→client win notification
- `@quenty/blend` — victory UI rendering (already available)
