## 1. Create CoinFloat Binder

- [x] 1.1 Create `src/modules/Client/Binders/CoinFloat.lua` — a BaseObject binder that stores the original CFrame, connects to RunService.Heartbeat, and applies `amplitude * math.sin(tick() * speed + phase)` Y-offset each frame
- [x] 1.2 Register the `CoinFloat` binder in `TestQuentyServiceClient.Init` using `Binder.new("Coin", require("CoinFloat"))` with the same tag as the server Coin binder

## 2. Testing

- [x] 2.1 Create `src/modules/Client/Binders/CoinFloat.spec.lua` — test that CoinFloat module loads and has expected structure
- [ ] 2.2 Run tests via `run_script_in_play_mode` to verify no errors and coins visually float

## 3. Verification

- [ ] 3.1 Start play mode and visually confirm coins bob up and down smoothly
- [ ] 3.2 Collect a coin and confirm no errors occur when the animated coin is destroyed
