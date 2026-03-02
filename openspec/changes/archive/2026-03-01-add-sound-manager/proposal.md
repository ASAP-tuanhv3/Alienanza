## Why

The game currently has no sound system. Adding a sound manager will allow playing sound effects (SFX) and background music with proper volume control, sound grouping, and lifecycle management — essential for game feel and player immersion.

## What Changes

- Add a `SoundService` (server) and `SoundServiceClient` (client) that integrate with ServiceBag
- Leverage Nevermore's `@quenty/sounds`, `@quenty/soundplayer`, and `@quenty/soundgroup` packages for sound playback and group management
- Add a `SoundConstants` shared module defining sound asset IDs and sound group configuration
- Add a client-side binder `SoundEmitter` for attaching positional sounds to tagged instances in the world
- Register sound services in the existing bootstrap services

## Capabilities

### New Capabilities
- `sound-playback`: Core sound playback system — playing one-shot SFX and looping music from client and server, with volume/pitch control
- `sound-emitters`: Positional sound emitters that attach to tagged Roblox instances using binders, for ambient and spatial audio

### Modified Capabilities

_(none)_

## Nevermore Packages

| Package | Relevance |
|---------|-----------|
| `@quenty/sounds` | Core sound management — sound definitions, lookup |
| `@quenty/soundplayer` | Sound playback utilities |
| `@quenty/soundgroup` | Sound group volume control (SFX, Music, Ambient) |
| `@quenty/binder` | Already in use — needed for `SoundEmitter` binder |
| `@quenty/maid` | Already in use — cleanup for sound instances |
| `@quenty/baseobject` | Already in use — base class for `SoundEmitter` |

## Impact

- **New files:** `SoundService.lua`, `SoundServiceClient.lua`, `SoundConstants.lua`, `SoundEmitter.lua`
- **Modified files:** `TestQuentyService.lua` (register SoundService), `TestQuentyServiceClient.lua` (register SoundServiceClient)
- **Dependencies:** `@quenty/sounds`, `@quenty/soundplayer`, `@quenty/soundgroup` (new pnpm installs)
- **Roblox services:** Uses `SoundService` (Roblox) internally for group routing
