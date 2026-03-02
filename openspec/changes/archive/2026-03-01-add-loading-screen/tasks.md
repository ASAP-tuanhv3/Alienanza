## 1. Dependencies

- [x] 1.1 Install required Nevermore packages: `@quenty/blend`, `@quenty/basicpane`, `@quenty/spring`, `@quenty/characterutils`

## 2. Loading Screen Pane

- [x] 2.1 Create `src/modules/Client/UI/LoadingScreenPane.lua` — Blend-based UI pane extending BasicPane with full-screen dark background, game title, status text (driven by ValueObject), and a loading indicator. Includes `SetStatusText(text)` method and spring-based fade-out on `Hide()`.

## 3. Loading Screen Service

- [x] 3.1 Create `src/modules/Client/LoadingScreenServiceClient.lua` — ServiceBag service that provides access to PlayerDataClient readiness (ObserveData) and character spawn waiting (CharacterPromiseUtils). Exposes helper methods for the boot sequence to query readiness.

## 4. Boot Sequence Integration

- [x] 4.1 Modify `src/scripts/Client/ClientMain.client.lua` — Implement the two-phase boot sequence: create LoadingScreenPane immediately, update status text through each phase (game loaded → services init/start → player data → character spawn → fade out), then destroy the pane.
- [x] 4.2 Register `LoadingScreenServiceClient` in `src/modules/Client/TestQuentyServiceClient.lua`

## 5. Unit Tests

- [x] 5.1 Create `src/modules/Client/UI/LoadingScreenPane.spec.lua` — TestEZ spec testing that the pane constructs, SetStatusText updates the value, Show/Hide toggle visibility, and the pane cleans up on Destroy
- [x] 5.2 Create `src/modules/Client/LoadingScreenServiceClient.spec.lua` — TestEZ spec testing that the service module loads without error (client module pcall + itSKIP pattern)

## 6. MCP Validation

- [x] 6.1 Run all test specs via `run_script_in_play_mode` using TestBootstrap:run() and verify all tests pass with zero failures
- [x] 6.2 Start play mode via MCP and visually verify the loading screen appears, shows status text updates, and fades out correctly

## 7. Final Review

- [x] 7.1 Confirm all unit tests pass, MCP validation succeeds, linting is clean, and the loading screen works end-to-end
