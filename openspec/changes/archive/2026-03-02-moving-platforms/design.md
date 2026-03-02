## Context

The game has three moving-platform assets (`block-moving`, `block-moving-blue`, `block-moving-large`) synced into `ReplicatedStorage.Assets` via Rojo but no runtime movement behavior. Existing binders (Coin, SpikeBlock) demonstrate the pattern: a shared constants module, a server binder for gameplay logic, and a client binder for visual effects, all registered through the main service files.

## Goals / Non-Goals

**Goals:**
- Platforms tagged `MovingPlatform` move between configurable waypoints at a configurable speed
- Players standing on a moving platform move with it (no sliding off)
- Client-side interpolation for smooth visual movement
- All three block-moving variants placed in TestArena with working configurations

**Non-Goals:**
- Complex path editors or spline-based paths — waypoints are simple position offsets stored as instance attributes
- Network ownership transfer — platforms are server-authoritative, clients interpolate visually
- Moving platforms that respond to player actions (buttons/levers) — future enhancement

## Decisions

### 1. Waypoint storage via Instance Attributes

**Decision:** Store waypoints as Vector3 attributes (`Waypoint1`, `Waypoint2`, etc.) on the tagged instance, representing world positions. The platform's initial CFrame is `Waypoint0` (implicit — the placement position).

**Rationale:** Attributes are visible in Studio properties, easy to configure without code, and survive Rojo sync. Alternatives considered:
- ObjectValue links to invisible parts: more visual in Studio but adds clutter and fragile references
- Encoded string attribute: harder to edit in Studio

### 2. Server-authoritative TweenService movement

**Decision:** The server binder uses `TweenService:Create()` to move platforms between waypoints. On reaching a waypoint, it pauses (`PAUSE_DURATION`) then tweens to the next, looping back to the start.

**Rationale:** TweenService replicates automatically to all clients — no custom networking needed. The tween runs on the server, so the platform's CFrame is authoritative. Alternatives considered:
- Heartbeat-based lerp: more control but requires manual replication
- AlignPosition constraint: physics-based, unpredictable timing

### 3. Client binder for player attachment

**Decision:** A client binder listens for the local character standing on a moving platform (raycast downward each frame) and applies a CFrame offset each frame so the player moves with the platform.

**Rationale:** Roblox's default physics doesn't reliably keep characters on server-tweened parts. The client binder compensates by tracking the platform's delta CFrame between frames and applying it to the character's root part. This is a common pattern in Roblox platformers.

### 4. Configuration via attributes with constant defaults

**Decision:** `MovingPlatformConstants` defines defaults (`SPEED = 8`, `PAUSE_DURATION = 1`, `EASING = Enum.EasingStyle.Sine`). Per-instance attributes (`Speed`, `PauseDuration`) override defaults when present.

**Rationale:** Allows level designers to tune individual platforms without code changes while maintaining sensible defaults.

## Risks / Trade-offs

- **[Sliding at high speed]** → At very high speeds, the client-side attachment may lag one frame behind. Mitigated by capping default speed and using pre-frame (Stepped) updates.
- **[TweenService replication jitter]** → TweenService replication can have minor visual artifacts on clients with high latency. Acceptable for a platformer; smooth enough for most cases.
- **[Waypoint count limit]** → No hard limit, but more than ~8 waypoints per platform increases attribute clutter. Acceptable for current scope.
