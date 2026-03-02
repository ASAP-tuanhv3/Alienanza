## ADDED Requirements

### Requirement: Level structure with five vertical zones
The level SHALL be organized into a `Workspace.ClimbingLevel` folder containing five zone sub-folders that stack vertically, each with a distinct theme and increasing difficulty.

#### Scenario: Level folder exists in Workspace
- **WHEN** the game loads
- **THEN** `Workspace.ClimbingLevel` SHALL exist as a Folder with sub-folders: `Zone1_Meadow`, `Zone2_Forest`, `Zone3_Canyon`, `Zone4_Snow`, `Zone5_Peak`, and `Decorations`

#### Scenario: Zones stack vertically
- **WHEN** measuring zone vertical ranges
- **THEN** Zone1 (Y: 0–10), Zone2 (Y: 10–50), Zone3 (Y: 50–90), Zone4 (Y: 90–140), Zone5 (Y: 140–160) SHALL not overlap and SHALL form a continuous upward path

### Requirement: Zone 1 — Spawn Meadow
The Spawn Meadow SHALL provide a safe, flat starting area using grass-large and grass-long blocks at ground level with the SpawnLocation and introductory decorations.

#### Scenario: Flat ground at spawn
- **WHEN** the player spawns
- **THEN** the SpawnLocation SHALL be on a flat grass-large block at approximately Y=6, surrounded by at least 3 additional flat grass blocks forming a connected meadow

#### Scenario: Tutorial coins at spawn
- **WHEN** the player leaves the spawn platform
- **THEN** there SHALL be a trail of at least 4 bronze coins leading toward Zone 2, placed at collectible height above the ground blocks

#### Scenario: Decorations in meadow
- **WHEN** viewing the spawn area
- **THEN** it SHALL contain at least: 2 trees, 1 flowers, 1 grass decoration, and 1 hedge placed on or near the ground blocks

### Requirement: Zone 2 — Forest Gauntlet
The Forest Gauntlet SHALL introduce platforming challenges with grass blocks at increasing heights, spike-block hazards, and dense forest decorations.

#### Scenario: Ascending platforms
- **WHEN** the player navigates Zone 2
- **THEN** there SHALL be at least 8 grass block platforms arranged in an ascending staircase pattern with gaps requiring jumps, rising from Y≈10 to Y≈50

#### Scenario: Spike hazards in forest
- **WHEN** the player encounters hazards in Zone 2
- **THEN** there SHALL be at least 2 spike-block or trap-spikes instances tagged with the SpikeBlock CollectionService tag, placed at chokepoints along the platforming path

#### Scenario: Forest decorations
- **WHEN** viewing Zone 2
- **THEN** it SHALL contain at least: 3 tree-pine models, 2 mushrooms, 1 rocks, and 2 flowers-tall placed on or near platforms

#### Scenario: Coins guide the path
- **WHEN** navigating Zone 2
- **THEN** bronze and silver coins SHALL be placed along the intended path, with at least 6 coins total in this zone

### Requirement: Zone 3 — Moving Platform Canyon
The Moving Platform Canyon SHALL feature large gaps that can only be crossed using moving platforms, utilizing all three block-moving variants.

#### Scenario: Moving platforms bridge gaps
- **WHEN** the player reaches Zone 3
- **THEN** there SHALL be at least 3 moving platforms (one of each variant: block-moving, block-moving-blue, block-moving-large) tagged with `MovingPlatform` and configured with `Waypoint1`/`Waypoint2` attributes spanning gaps between static platforms

#### Scenario: Static rest platforms between gaps
- **WHEN** between moving platform segments
- **THEN** there SHALL be grass block rest platforms where the player can safely stand, with at least 2 rest platforms in this zone

#### Scenario: Coins on moving platforms
- **WHEN** riding moving platforms
- **THEN** at least 2 silver coins SHALL be placed at positions reachable from moving platforms

#### Scenario: Canyon decorations
- **WHEN** viewing Zone 3
- **THEN** it SHALL contain at least: fences along edges of rest platforms, rocks below the canyon, and 1 sign prop

### Requirement: Zone 4 — Snow Summit
The Snow Summit SHALL use snow-themed blocks with steep slopes, narrow ledges, and spike traps to create the most challenging section.

#### Scenario: Snow block terrain
- **WHEN** the player enters Zone 4
- **THEN** all terrain blocks SHALL be snow-themed variants (block-snow-*), including at least: 2 narrow blocks, 2 slope blocks, and 1 large block

#### Scenario: Spike traps on narrow ledges
- **WHEN** navigating narrow snow ledges
- **THEN** there SHALL be at least 2 spike hazards (spike-block or trap-spikes-large) placed on or adjacent to narrow passages

#### Scenario: Snow decorations
- **WHEN** viewing Zone 4
- **THEN** it SHALL contain at least: 2 tree-pine-snow models, 1 tree-snow, and 1 stones decoration

#### Scenario: Gold coins as high-value reward
- **WHEN** navigating Zone 4
- **THEN** at least 2 gold coins SHALL be placed at challenging-to-reach positions

### Requirement: Zone 5 — Victory Peak
The Victory Peak SHALL be the final platform at the top of the level, clearly marked with a star collectible and flag.

#### Scenario: Summit platform
- **WHEN** the player reaches the top
- **THEN** there SHALL be a snow block platform at approximately Y=150 large enough for the player to stand on

#### Scenario: Victory star placement
- **WHEN** viewing the summit
- **THEN** a star model SHALL be placed above the summit platform, tagged with `WinZone` for win detection

#### Scenario: Flag at summit
- **WHEN** viewing the summit
- **THEN** a flag model SHALL be placed on the summit platform as a visual landmark visible from below

### Requirement: Baseplate and kill zone
The level SHALL have a baseplate or kill floor below the level to catch fallen players.

#### Scenario: Fall reset
- **WHEN** a player falls below Y = -20
- **THEN** the player's character SHALL be eliminated (via the existing Roblox FallenPartsDestroyHeight or a kill brick), causing respawn at SpawnLocation
