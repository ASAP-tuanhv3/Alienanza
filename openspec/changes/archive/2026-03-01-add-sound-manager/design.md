## Context

The game has no audio system. Players experience the game silently — no UI feedback sounds, no ambient audio, no music. The Nevermore ecosystem provides three sound-related packages (`@quenty/sounds`, `@quenty/soundplayer`, `@quenty/soundgroups`) that handle low-level sound creation, looped playback, and group volume control respectively. This design builds a thin game-specific layer on top of them.

## Goals / Non-Goals

**Goals:**
- Provide a simple API for playing one-shot SFX and looping music from any client-side module
- Support positional/spatial audio via binder-based sound emitters on tagged instances
- Organize sounds into groups (SFX, Music, Ambient) with independent volume control
- Follow Nevermore conventions: ServiceBag lifecycle, Binder pattern, strict Luau

**Non-Goals:**
- Server-authoritative sound (all playback is client-side; server service only manages shared config)
- Dynamic music system with crossfading/layering (future enhancement)
- Sound settings UI or player volume preferences (future enhancement)
- Procedural audio or DSP effects

## Decisions

### 1. Client-side playback only

Sound playback happens exclusively on the client via `SoundServiceClient`. The server-side `SoundService` exists only to register shared dependencies (like `SoundConstants`) and handle any future server-to-client sound triggers.

**Rationale:** Roblox `Sound` objects only produce audio on the client. Server-side sound creation adds network overhead with no benefit for basic playback. Keeping playback client-only is simpler and matches how Nevermore's sound packages work.

**Alternative considered:** Server-triggered sounds via RemoteEvents — adds complexity without clear need at this stage.

### 2. Centralized sound definitions in SoundConstants

All sound asset IDs, default properties (volume, pitch, looped), and group assignments live in a single `SoundConstants` shared module. Services reference sounds by name key, not raw asset ID.

**Rationale:** Single source of truth prevents scattered magic numbers. Easy to add/modify sounds without touching service code. Shared module means both client and server can reference the same definitions.

### 3. Use Nevermore sound packages as foundation

- `@quenty/sounds` (`SoundUtils`) — for creating and playing one-shot sounds
- `@quenty/soundplayer` (`LoopedSoundPlayer`) — for background music loops
- `@quenty/soundgroups` — for SoundGroup volume hierarchy

**Rationale:** These packages are maintained, tested, and follow Nevermore patterns. Building on them avoids reimplementing sound lifecycle management.

### 4. SoundEmitter as a Binder

Positional sounds use a `SoundEmitter` binder class that attaches to instances tagged `SoundEmitter` via CollectionService. The binder reads attributes from the instance (`SoundName`, `Volume`, `Looped`) to configure playback.

**Rationale:** Binder pattern is the standard Nevermore approach for instance-attached behavior. Designers can place sound emitters in Studio by tagging parts and setting attributes — no code changes needed.

### 5. Module structure

```
src/modules/
├── Client/
│   ├── Binders/
│   │   └── SoundEmitter.lua        # Binder: positional sounds on tagged instances
│   └── SoundServiceClient.lua      # Client service: playback API
├── Server/
│   └── SoundService.lua            # Server service: registers shared deps
└── Shared/
    └── SoundConstants.lua           # Sound definitions and group config
```

## Risks / Trade-offs

- **[Limited initial scope]** → No music crossfading or dynamic layers. Acceptable for v1; can be added later without breaking the API.
- **[Package API uncertainty]** → Nevermore sound packages may have undocumented quirks. Mitigation: keep a thin wrapper so we can swap implementations if needed.
- **[No volume persistence]** → Player volume preferences are not saved. Mitigation: explicitly a non-goal; can layer on `@quenty/settings` later.
