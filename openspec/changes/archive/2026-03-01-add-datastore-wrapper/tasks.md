## 1. Dependencies

- [x] 1.1 Install required Nevermore packages: `@quenty/playerutils`, `@quenty/rx`, `@quenty/valueobject`, `@quenty/remoting`, `@quenty/bindtocloseservice`, `@quenty/promise`

## 2. Shared Module

- [x] 2.1 Create `src/modules/Shared/PlayerDataConstants.lua` with `TEMPLATE` (default data table) and `STORE_NAME` fields

## 3. Server Service

- [x] 3.1 Create `src/modules/Server/PlayerDataService.lua` — ServiceBag service wrapping ProfileStore with Init/Start lifecycle
- [x] 3.2 Implement profile session start on player join using `RxPlayerUtils.observePlayersBrio()` and `ProfileStore:StartSessionAsync()`
- [x] 3.3 Implement profile session end on player leave (Maid cleanup calls `Profile:EndSession()`)
- [x] 3.4 Implement `Profile.OnSessionEnd` handler to kick player if session is stolen
- [x] 3.5 Implement `PromisePlayerProfile(player)` method returning a Promise that resolves with the active Profile
- [x] 3.6 Implement BindToClose shutdown handling via `@quenty/bindtocloseservice` to end all sessions
- [x] 3.7 Implement Studio mock support — use `ProfileStore.Mock` when `RunService:IsStudio()` is true
- [x] 3.8 Implement client data replication — send data to client via Remoting on profile load and after saves

## 4. Client Service

- [x] 4.1 Create `src/modules/Client/PlayerDataClient.lua` — ServiceBag client service that receives replicated data via Remoting
- [x] 4.2 Implement `ObserveData()` method returning an Observable of the player's data table

## 5. Service Registration

- [x] 5.1 Register `PlayerDataService` in `TestQuentyService.Init()`
- [x] 5.2 Register `PlayerDataClient` in `TestQuentyServiceClient.Init()`

## 6. Unit Tests

- [x] 6.1 Create `src/modules/Shared/PlayerDataConstants.spec.lua` — verify TEMPLATE and STORE_NAME exist and have correct types
- [x] 6.2 Create `src/modules/Server/PlayerDataService.spec.lua` — verify service structure, ServiceName, and method existence
- [x] 6.3 Create `src/modules/Client/PlayerDataClient.spec.lua` — verify client service structure (use pcall+itSKIP pattern for server context)

## 7. MCP Validation

- [x] 7.1 Run all spec files via `run_script_in_play_mode` with `TestBootstrap:run()` and verify all tests pass

## 8. Final Review

- [x] 8.1 Confirm all unit tests pass, MCP validation succeeds, linting is clean, and the change is production-ready
