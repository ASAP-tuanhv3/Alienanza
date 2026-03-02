## Why

The game currently has coins to collect but no hazards to avoid. Adding spike-blocks introduces risk/reward gameplay — players must navigate around dangerous obstacles while collecting coins, making the platforming more engaging.

## What Changes

- Add a new **SpikeBlock** hazard that damages the player on contact
- Server-side binder detects player collision and applies 1 heart of damage
- Grant 1.5 seconds of invincibility frames (i-frames) after taking damage
- Visual feedback: player character flashes during i-frames
- Sound effect plays on damage
- Place spike-block instances in the test arena
- Add `SpikeBlockConstants` shared module for configuration

## Capabilities

### New Capabilities

- `hazard-spike-block`: Spike-block hazard that damages players on touch, with i-frames and visual/audio feedback

### Modified Capabilities

_None — this is a new standalone system._

## Impact

- **New files**: `SpikeBlockConstants.lua` (Shared), `SpikeBlock.lua` (Server binder), `SpikeBlockService.lua` (Server), `SpikeBlockServiceClient.lua` (Client), `SpikeBlockDamageEffect.lua` (Client binder for i-frame flash)
- **Modified files**: `TestQuentyService.lua` (register SpikeBlockService), `TestQuentyServiceClient.lua` (register SpikeBlockServiceClient), `SoundConstants.lua` (add damage sound)
- **Workspace**: Spike-block parts tagged with `"SpikeBlock"` placed in the test arena

## Nevermore Packages

Relevant packages already in use or available:
- `@quenty/binder` — used for the SpikeBlock binder (already installed)
- `@quenty/baseobject` — base class for binder (already installed)
- `@quenty/characterutils` — detect player from touched part (already installed)
- `@quenty/humanoidutils` — apply damage to humanoid (already installed)
- `@quenty/remoting` — server→client damage notification (already installed)

No new package installations needed.
