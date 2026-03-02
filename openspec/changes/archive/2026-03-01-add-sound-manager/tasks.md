## 1. Dependencies

- [x] 1.1 Install Nevermore sound packages: `pnpm install @quenty/sounds @quenty/soundplayer @quenty/soundgroup @quenty/baseobject @quenty/maid`

## 2. Shared Module

- [x] 2.1 Create `src/modules/Shared/SoundConstants.lua` with sound definitions table (name -> asset ID, group, volume, pitch, looped), group enum (SFX, Music, Ambient), and example entries

## 3. Server Service

- [x] 3.1 Create `src/modules/Server/SoundService.lua` following the ServiceBag service template with Init/Start methods
- [x] 3.2 Register `SoundService` in `TestQuentyService.Init`

## 4. Client Service

- [x] 4.1 Create `src/modules/Client/SoundServiceClient.lua` with ServiceBag lifecycle, sound group setup, `PlaySound`, `PlayMusic`, and `StopMusic` methods
- [x] 4.2 Register `SoundServiceClient` in `TestQuentyServiceClient.Init`

## 5. Sound Emitter Binder

- [x] 5.1 Create `src/modules/Client/Binders/SoundEmitter.lua` extending BaseObject, reading SoundName/Volume/Looped attributes, creating positional Sound instances, routing to Ambient group
- [x] 5.2 Register `SoundEmitter` binder in `SoundServiceClient.Init`

## 6. Formatting and Linting

- [x] 6.1 Run `npm run format` to format all new files with StyLua
- [x] 6.2 Run `npm run lint:selene` and `npm run lint:luau` to verify no lint errors

## 7. Validation

- [x] 7.1 Validate server initialization via Roblox MCP: start play, verify SoundService initializes without errors
- [x] 7.2 Validate client SoundServiceClient initializes, sound groups are created under SoundService
- [x] 7.3 Validate PlaySound plays a one-shot sound and auto-cleans up
- [x] 7.4 Validate PlayMusic starts looping music and StopMusic stops it
- [x] 7.5 Validate SoundEmitter binder attaches sounds to tagged instances
- [x] 7.6 Final review: confirm all files use --!strict, have Moonwave docstrings, follow naming conventions
