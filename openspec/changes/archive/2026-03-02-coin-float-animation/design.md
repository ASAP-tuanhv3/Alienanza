## Context

Coins in the game use the server-side `Coin` binder (CollectionService tag `"Coin"`) for collection logic. They are static BaseParts with no visual animation. The client already has `CoinServiceClient` for handling collection effects. Adding a floating animation is purely cosmetic and belongs entirely on the client side.

## Goals / Non-Goals

**Goals:**
- Smooth sine-wave floating animation on all tagged coins, running client-side
- Clean lifecycle management — animation stops when coin is collected/destroyed
- Minimal performance impact

**Non-Goals:**
- Rotation animation (only Y-axis translation)
- Server-side movement (animation is visual only, no physics replication)
- Configurable amplitude/speed per coin type

## Decisions

### 1. Client-side Binder for animation

**Choice**: Create a `CoinFloat` binder registered in `TestQuentyServiceClient` that attaches to instances tagged `"Coin"`.

**Why over alternatives**:
- A binder automatically attaches/detaches as coins are added/removed from workspace
- Follows the existing project pattern (server `Coin` binder handles collection, client `CoinFloat` handles visuals)
- Cleaner than a single loop iterating over all coins

### 2. RunService.Heartbeat for per-frame updates

**Choice**: Use a `Heartbeat` connection inside each `CoinFloat` binder instance to update position every frame.

**Why**: Heartbeat runs after physics, giving smooth visual results. Using `StepUtils` from `@quenty/steputils` is unnecessary complexity for a simple sine offset — a direct Heartbeat connection via Maid is sufficient.

### 3. Store original Y position, apply sine offset

**Choice**: On bind, capture the coin's original `CFrame`. Each frame, set the coin's `CFrame` to `originalCFrame + Vector3.new(0, amplitude * math.sin(tick() * speed), 0)`.

**Why**: Preserving the original CFrame means the animation is purely additive and doesn't drift. Using `tick()` gives a continuous time source. Each coin can use its own phase offset (based on original position) to avoid all coins moving in sync.

### 4. Animation parameters

- **Amplitude**: 0.5 studs (subtle but visible bob)
- **Speed**: 3 (frequency multiplier — completes roughly one cycle per 2 seconds)
- **Phase offset**: Derived from original Y position to desync coins naturally

## Risks / Trade-offs

- **[Network ownership]** Client setting CFrame on server-owned parts may cause jitter → Coins are anchored and non-collidable (confirmed by existing `Coin` binder setting `CanCollide = false`), so client CFrame writes work fine for anchored parts.
- **[Many coins]** One Heartbeat connection per coin could be expensive with hundreds of coins → For the current scale (9 coins) this is negligible. If coin count grows significantly, consolidate into a single Heartbeat loop.
