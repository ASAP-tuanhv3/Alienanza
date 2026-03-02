## Context

The game has a small TestArena with scattered blocks and a few coins/hazards placed for testing. Existing binder systems (MovingPlatform, SpikeBlock, Coin float) are functional. The asset library (`assets.json`) contains 153 models across 14 categories — grass blocks, snow blocks, moving platforms, collectibles, hazards, nature, props, fences, and more. We need to replace TestArena with a designed vertical climbing level that uses these systems and assets together.

The level will be built entirely via a Lua build script executed through MCP `run_code`, placing asset models from `ReplicatedStorage` (synced by Rojo) into Workspace. Block dimensions from the asset library are approximately:
- Standard block: ~8×10×8 studs
- Large block: ~16×10×16 studs
- Long block: ~8×10×16 studs
- Narrow block: ~4×10×8 studs
- Low variants: ~half height (~5 studs)

## Goals / Non-Goals

**Goals:**
- Create a complete, playable vertical climbing level with 5 themed zones
- Use all functional systems: MovingPlatform binder, SpikeBlock binder, Coin float binder
- Place decorative assets (trees, flowers, rocks, fences, mushrooms, hedges) for visual polish
- Implement a win condition when reaching the summit star
- Guide the player path using coin breadcrumbs (bronze → silver → gold)

**Non-Goals:**
- Checkpoints or respawn system (player respawns at SpawnLocation on death)
- Leaderboard or persistent level completion tracking (out of scope — player-data exists but win state is session-only)
- Multiple difficulty paths or branching routes
- Procedural generation — this is a hand-crafted static level

## Decisions

### 1. Level built via run_code script, not manual placement

**Decision:** Build the level programmatically using a Lua script that clones models from assets and positions them in Workspace.

**Rationale:** This is reproducible, version-controllable, and allows precise coordinate-based placement. Manual Studio placement would be lost on Rojo sync. The script will reference models already in the game tree (synced via Rojo from `src/assets/models/`).

**Alternative considered:** Manual placement in Studio — rejected because it doesn't persist through Rojo syncs and isn't reproducible.

### 2. Five vertical zones with theme transitions

**Decision:** Structure the level as 5 stacked zones, each ~40-60 studs of vertical gain:
1. **Spawn Meadow** (Y: 0–10) — grass-large blocks as flat ground, SpawnLocation, tutorial coins, decorative trees/flowers
2. **Forest Gauntlet** (Y: 10–50) — grass blocks forming stepping platforms, spike-block hazards, nature decorations
3. **Moving Platform Canyon** (Y: 50–90) — large gaps bridged by moving platforms (all 3 variants), coins on platforms
4. **Snow Summit** (Y: 90–140) — snow-themed blocks with slopes, narrow ledges, spike traps, snow trees
5. **Victory Peak** (Y: 140–160) — final snow platform with gold star and flag

**Rationale:** Themed zones create visual variety and a sense of progression. Vertical layout makes "climb to the top" the clear goal. Each zone introduces or combines a mechanic.

### 3. Win condition via tagged part + binder

**Decision:** Use a `WinZone` CollectionService tag on the victory star/platform. A server-side binder detects Touched events from player characters. On trigger, fire a RemoteEvent to the winning player's client to show victory UI.

**Rationale:** Consistent with existing binder architecture. Simple Touched detection is reliable for a single victory zone. Using Remoting keeps server authority over win state.

**Alternative considered:** Proximity prompt — rejected as less thematic (player should just reach the area, not interact with a prompt).

### 4. Victory UI via Blend

**Decision:** Client-side `WinConditionServiceClient` listens for the win remote event and renders a full-screen congratulatory overlay using Blend, with the player's total coin count.

**Rationale:** Blend is already available in the project. A simple overlay is lightweight and doesn't require complex UI state.

### 5. Level geometry in a "ClimbingLevel" folder

**Decision:** All level parts go into `Workspace.ClimbingLevel` folder, replacing the existing `TestArena` folder. Sub-folders organize by zone: `Zone1_Meadow`, `Zone2_Forest`, `Zone3_Canyon`, `Zone4_Snow`, `Zone5_Peak`, and `Decorations`.

**Rationale:** Clean organization makes it easy to find and modify sections. Zone folders allow selective loading in the future if needed.

## Risks / Trade-offs

**[Risk] Large number of parts may impact performance** → Mitigation: Use StreamingEnabled. The level is moderate in scope (~200-300 instances total), well within Roblox limits. Low-poly asset models keep triangle counts manageable.

**[Risk] Moving platform waypoints must be configured correctly** → Mitigation: The build script sets `Waypoint1`/`Waypoint2` Vector3 attributes directly on placement. Existing MovingPlatform binder handles the rest.

**[Risk] Player can fall off and must restart from spawn** → Mitigation: This is intentional difficulty for a climbing game. The spawn meadow is safe and clearly marked. Future work could add checkpoints.

**[Risk] Build script must reference correct model paths** → Mitigation: Models are synced by Rojo into the game tree. The script will clone from known paths and error clearly if a model is missing.

## Nevermore Packages

Packages already in use — no new installations needed:
- `@quenty/binder` — WinZone binder
- `@quenty/servicebag` — service registration
- `@quenty/baseobject` — base class for WinZone binder
- `@quenty/maid` — cleanup
- `@quenty/remoting` — win notification remote event
- `@quenty/blend` — victory UI
- `@quenty/playerutils` — player detection in win zone
