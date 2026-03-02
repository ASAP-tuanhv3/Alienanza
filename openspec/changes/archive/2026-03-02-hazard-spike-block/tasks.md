## 1. Shared Constants

- [x] 1.1 Create `src/modules/Shared/SpikeBlockConstants.lua` with TAG, DAMAGE, IFRAME_DURATION, and REMOTE_EVENT_NAME
- [x] 1.2 Add `SpikeBlockHit` sound entry to `src/modules/Shared/SoundConstants.lua`

## 2. Server Implementation

- [x] 2.1 Create `src/modules/Server/Binders/SpikeBlock.lua` — binder that detects player touch, checks i-frames, and deals damage via Humanoid:TakeDamage()
- [x] 2.2 Create `src/modules/Server/SpikeBlockService.lua` — registers SpikeBlock binder and fires damage remote event to client
- [x] 2.3 Register SpikeBlockService in `src/modules/Server/TestQuentyService.lua`

## 3. Client Implementation

- [x] 3.1 Create `src/modules/Client/SpikeBlockServiceClient.lua` — listens for damage remote event, plays sound, triggers flash effect
- [x] 3.2 Register SpikeBlockServiceClient in `src/modules/Client/TestQuentyServiceClient.lua`

## 4. Place Spike-Blocks in Arena

- [x] 4.1 Add SpikeBlock-tagged parts to the test arena workspace via Roblox Studio MCP

## 5. Testing

- [x] 5.1 Create `src/modules/Shared/SpikeBlockConstants.spec.lua` unit test
- [x] 5.2 Playtest: verify spike damage, i-frames, flash effect, and sound in Studio
