## 1. Shared Constants & Module Setup

- [x] 1.1 Create `src/modules/Shared/WinConditionConstants.lua` with `TAG_NAME = "WinZone"` and `REMOTE_EVENT_NAME = "WinConditionNotify"`

## 2. Server-Side Win Condition

- [x] 2.1 Create `src/modules/Server/Binders/WinZone.lua` — binder that listens for Touched on tagged `WinZone` instances, detects player humanoid, fires RemoteEvent to winning player (with dedup per player)
- [x] 2.2 Create `src/modules/Server/WinConditionService.lua` — registers WinZone binder and sets up Remoting for win notification
- [x] 2.3 Register `WinConditionService` in `TestQuentyService.Init`

## 3. Client-Side Win Condition

- [x] 3.1 Create `src/modules/Client/WinConditionServiceClient.lua` — listens for win remote event and displays victory overlay UI using Blend (title, subtitle, coin count), with fade-in animation
- [x] 3.2 Register `WinConditionServiceClient` in `TestQuentyServiceClient.Init`

## 4. Build Level — Zone 1: Spawn Meadow

- [x] 4.1 Remove existing TestArena folder from Workspace via run_code
- [x] 4.2 Create ClimbingLevel folder structure (Zone1_Meadow, Zone2_Forest, Zone3_Canyon, Zone4_Snow, Zone5_Peak, Decorations) via run_code
- [x] 4.3 Place grass-large and grass-long blocks as flat ground platforms at Y≈5, place SpawnLocation at Y≈6
- [x] 4.4 Place 4+ bronze coins trailing from spawn toward Zone 2
- [x] 4.5 Place decorations: 2 trees, 1 flowers, 1 grass, 1 hedge on meadow ground

## 5. Build Level — Zone 2: Forest Gauntlet

- [x] 5.1 Place 8+ ascending grass block platforms from Y≈10 to Y≈50 with jumpable gaps
- [x] 5.2 Place 2+ spike-block hazards at chokepoints, tagged with `SpikeBlock`
- [x] 5.3 Place 6+ coins (bronze and silver) along the platforming path
- [x] 5.4 Place forest decorations: 3 tree-pine, 2 mushrooms, 1 rocks, 2 flowers-tall

## 6. Build Level — Zone 3: Moving Platform Canyon

- [x] 6.1 Place static rest platforms (grass blocks) at Y≈50–90 with large gaps between them
- [x] 6.2 Place 3 moving platforms (block-moving, block-moving-blue, block-moving-large) tagged `MovingPlatform` with Waypoint1/Waypoint2 attributes spanning gaps
- [x] 6.3 Place 2+ silver coins reachable from moving platforms
- [x] 6.4 Place canyon decorations: fences on rest platform edges, rocks below, 1 sign

## 7. Build Level — Zone 4: Snow Summit

- [x] 7.1 Place snow-themed blocks (narrow, slope, large) from Y≈90 to Y≈140 forming challenging terrain
- [x] 7.2 Place 2+ spike hazards on or adjacent to narrow snow passages
- [x] 7.3 Place 2+ gold coins at challenging positions
- [x] 7.4 Place snow decorations: 2 tree-pine-snow, 1 tree-snow, 1 stones

## 8. Build Level — Zone 5: Victory Peak

- [x] 8.1 Place a snow block summit platform at Y≈150
- [x] 8.2 Place a star model above the summit, tagged with `WinZone`
- [x] 8.3 Place a flag model on the summit as a visual landmark
- [x] 8.4 Set FallenPartsDestroyHeight to -50 or place a kill brick below Y=-20

## 9. Testing & Polish

- [x] 9.1 Playtest the full level in play mode — verify spawn, platforming, coin collection, spike damage, moving platforms, and win condition trigger
- [x] 9.2 Adjust platform spacing/heights if jumps are impossible or trivial
- [x] 9.3 Verify all binder tags work (Coin, SpikeBlock, MovingPlatform, WinZone)
