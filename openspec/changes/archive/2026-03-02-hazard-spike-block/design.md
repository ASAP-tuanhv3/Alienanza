## Context

The game is a 3D platformer built with Nevermore Engine. Players currently collect coins using a Binder-based system (CollectionService tag → server binder detects touch → processes collection). There are no hazards yet. The design doc for the game world specifies spike hazards that deal 1 heart of damage.

The existing Coin binder provides a proven pattern: server binder handles `.Touched` events, uses `CharacterUtils.getPlayerFromCharacter()` to identify the player, then processes the interaction. We'll follow this same pattern for spike-blocks.

Roblox Humanoids have a built-in health system. The default max health is 100. We'll map "1 heart = 25 HP" (giving 4 hearts at 100 HP), keeping things simple while matching the design doc's 3-heart base (75 HP max, configurable).

## Goals / Non-Goals

**Goals:**
- Spike-blocks damage players on contact following the established binder pattern
- I-frames prevent rapid repeated damage (1.5s cooldown)
- Visual flash feedback on the client so players know they were hit
- Sound feedback on damage
- Spike-blocks placed in the test arena for immediate gameplay

**Non-Goals:**
- Health HUD / heart display (separate feature)
- Knockback physics on damage
- Checkpoint/respawn system
- Other hazard types (saws, bombs) — those follow the same pattern later
- Spike animation or movement

## Decisions

### 1. Server-authoritative damage with i-frame tracking

**Decision:** The server binder handles all damage and tracks i-frame cooldowns per-player using a dictionary `_iframePlayers: { [Player]: number }` storing `tick()` timestamps.

**Why:** Server authority prevents exploits. A simple timestamp dictionary is sufficient — no need for a full cooldown system when we only track one state per player.

**Alternative considered:** Using `@quenty/cooldown` package — overkill for a simple per-player timestamp check.

### 2. Use Humanoid:TakeDamage() for damage

**Decision:** Call `Humanoid:TakeDamage(damageAmount)` directly on the server.

**Why:** Built-in Roblox method that respects ForceField and fires `Humanoid.HealthChanged`. Simple and reliable. The Coin system already accesses humanoids via CharacterUtils, so this is consistent.

**Alternative considered:** Custom health ValueObject — unnecessary complexity when we can use the built-in humanoid health.

### 3. Client-side flash effect via remoting

**Decision:** Server fires a remote event to the damaged player. Client plays a damage sound and runs a transparency flash on the character model (toggle transparency every 0.15s for 1.5s).

**Why:** Keeps visual effects client-side where they belong. The remote event pattern matches how CoinService notifies CoinServiceClient. The flash effect is simple RunService-driven transparency toggling on the character model.

### 4. Tag-based spike-block identification

**Decision:** Use CollectionService tag `"SpikeBlock"` on parts in the workspace. Any tagged part becomes a spike-block hazard.

**Why:** Matches the Coin pattern exactly. Level designers tag parts in Studio, binder auto-attaches behavior. No special instance hierarchy needed.

### 5. Constants module for configuration

**Decision:** `SpikeBlockConstants.lua` in Shared with tag name, damage amount, i-frame duration, and remote event name.

**Why:** Follows `CoinConstants` pattern. Centralizes tuning values.

## Risks / Trade-offs

- **[Risk] Touched event unreliability at high speed** → Roblox `.Touched` can miss fast-moving parts. Acceptable for static spike-blocks; moving hazards would need raycasting (out of scope).
- **[Risk] No health HUD yet** → Players won't see their health visually. The flash effect provides immediate feedback. Health HUD is a separate feature.
- **[Trade-off] Using built-in Humanoid health** → Ties us to Roblox's health system. If we later want custom health, we'd need to migrate. For now, simplicity wins.
- **[Trade-off] No knockback** → Players can sit on spikes and take repeated damage every 1.5s. Acceptable for first implementation; knockback can be added later.
