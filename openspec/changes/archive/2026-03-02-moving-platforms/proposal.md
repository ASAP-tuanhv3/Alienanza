## Why

The game needs moving platforms to add dynamic traversal challenges. The `block-moving`, `block-moving-blue`, and `block-moving-large` assets exist in `ReplicatedStorage.Assets` but have no runtime behavior — they need a server-side movement system and client-side smooth interpolation so players can ride platforms that move between waypoints.

## What Changes

- Add a `MovingPlatform` server binder that reads waypoint attributes from tagged instances, then tweens them back and forth along a defined path
- Add a `MovingPlatformClient` client binder for smooth visual interpolation so platforms don't stutter on clients
- Add `MovingPlatformConstants` shared module for tag name, default speed, pause duration, and other tuning values
- Register the binder in `TestQuentyService` (server) and `TestQuentyServiceClient` (client)
- Place the three block-moving models in the TestArena workspace with the `MovingPlatform` tag and waypoint configuration so they work out of the box

## Capabilities

### New Capabilities
- `moving-platform`: Server-driven platform movement between waypoints with configurable speed, pause time, and easing; client-side smooth interpolation; tag-based activation using the Binder pattern

### Modified Capabilities

## Impact

- **New files:** `MovingPlatformConstants.lua` (Shared), `MovingPlatform.lua` (Server/Binders), `MovingPlatformClient.lua` (Client/Binders)
- **Modified files:** `TestQuentyService.lua` (register server binder), `TestQuentyServiceClient.lua` (register client binder)
- **Assets used:** `block-moving.rbxm`, `block-moving-blue.rbxm`, `block-moving-large.rbxm` from `ReplicatedStorage.Assets`
- **Nevermore Packages:** Uses existing `@quenty/binder`, `@quenty/baseobject`, `@quenty/maid`, `@quenty/steputils` (for RunService step bindings). No new packages needed.
