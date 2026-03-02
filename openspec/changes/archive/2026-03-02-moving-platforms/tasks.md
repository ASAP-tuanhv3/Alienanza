## 1. Shared Constants

- [x] 1.1 Create `src/modules/Shared/MovingPlatformConstants.lua` with TAG name (`MovingPlatform`), default SPEED (8), PAUSE_DURATION (1), EASING_STYLE (Enum.EasingStyle.Sine), EASING_DIRECTION (Enum.EasingDirection.InOut)

## 2. Server Binder

- [x] 2.1 Create `src/modules/Server/Binders/MovingPlatform.lua` — BaseObject-based binder that reads `Waypoint1..N` Vector3 attributes, computes tween duration from distance/speed, and tweens the instance between waypoints in a loop with pause at each waypoint
- [x] 2.2 Register `MovingPlatform` binder in `TestQuentyService.Init` following the existing Coin/SpikeBlock pattern

## 3. Client Binder

- [x] 3.1 Create `src/modules/Client/Binders/MovingPlatformClient.lua` — BaseObject-based binder that tracks the local player's character, raycasts downward each frame to detect if standing on the platform, and applies the platform's CFrame delta to the character's HumanoidRootPart
- [x] 3.2 Register `MovingPlatformClient` binder in `TestQuentyServiceClient.Init`

## 4. Place Assets in TestArena

- [x] 4.1 Place `block-moving`, `block-moving-blue`, and `block-moving-large` models from `ReplicatedStorage.Assets` into the TestArena workspace via Roblox Studio (run_code), tag them with `MovingPlatform`, and set waypoint attributes for each

## 5. Verification

- [x] 5.1 Run play mode and verify all three platforms move between their waypoints, pause correctly, and players can ride them without sliding off
