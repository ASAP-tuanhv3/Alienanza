## Why

Coins in the game are static and visually uninteresting. Adding a floating bob animation using a sine function makes them more visible and appealing, signaling to players that they are collectible items.

## What Changes

- Add a client-side floating animation to all coins tagged with "Coin"
- Coins will smoothly oscillate up and down on the Y-axis using `math.sin(tick())`
- Animation runs on the client via RunService.Heartbeat for smooth per-frame updates

## Nevermore Packages

- `@quenty/steputils` — Provides `StepUtils` for RunService step utilities, useful for managing per-frame updates cleanly with Maid cleanup
- Existing `@quenty/binder` and `@quenty/baseobject` already in use for the Coin binder pattern

## Capabilities

### New Capabilities
- `coin-float`: Client-side sine-wave floating animation for tagged coin instances

### Modified Capabilities

## Impact

- **Client code**: New `CoinFloat` binder in `src/modules/Client/Binders/` registered via `TestQuentyServiceClient`
- **Server code**: No changes — animation is purely cosmetic and client-side
- **Performance**: Minimal — uses Heartbeat connection per active coin with simple math
- **Dependencies**: May add `@quenty/steputils` if not already installed
