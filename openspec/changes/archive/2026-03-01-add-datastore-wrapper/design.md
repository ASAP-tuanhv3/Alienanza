## Context

The project needs persistent player data. ProfileStore (`src/modules/Server/ProfileStore.luau`) is already in the codebase — it provides session-locked DataStore access with auto-saving. We need a Nevermore-style service layer so other game services can access player data through the ServiceBag without coupling to ProfileStore directly.

Currently installed Nevermore packages include `@quenty/servicebag`, `@quenty/maid`, and `@quenty/baseobject`. Additional packages (`@quenty/playerutils`, `@quenty/rx`, `@quenty/valueobject`, `@quenty/remoting`, `@quenty/bindtocloseservice`) will be installed for player lifecycle management, data observation, and client replication.

## Goals / Non-Goals

**Goals:**
- Wrap ProfileStore in a `PlayerDataService` that follows ServiceBag Init/Start lifecycle
- Automatically start/end profile sessions on player join/leave
- Provide a promise-based API: `PlayerDataService:PromisePlayerProfile(player)` → resolves with the active profile
- Replicate select player data to the client via `@quenty/remoting` so UI can observe it
- Ensure all sessions are saved and closed on server shutdown via `@quenty/bindtocloseservice`
- Expose a `PlayerDataConstants` module for the data template and store name

**Non-Goals:**
- Global (non-player) DataStore access — out of scope
- Data migration tooling or version management
- Admin commands for data manipulation (can be added later via CmdrService)
- Offline/external data editing API

## Decisions

### 1. ProfileStore over `@quenty/datastore`

**Decision:** Use ProfileStore directly instead of `@quenty/datastore`.

**Rationale:** The user has already added ProfileStore and chosen its session-locking model. ProfileStore handles auto-save, session stealing prevention, and BindToClose internally. Wrapping `@quenty/datastore` around ProfileStore would add unnecessary indirection.

**Alternative considered:** Using `@quenty/datastore` + `PlayerDataStoreService` — rejected because ProfileStore has its own session model that conflicts with Nevermore's DataStore wrapper.

### 2. Service structure: three modules

**Decision:** Create three modules:
- `PlayerDataConstants` (Shared) — data template, store name config
- `PlayerDataService` (Server) — ProfileStore wrapper service
- `PlayerDataClient` (Client) — receives replicated data

**Rationale:** Follows existing project pattern (`SoundService`/`SoundServiceClient`/`SoundConstants`). Constants in Shared allows both server and client to reference the data template for type safety.

### 3. Player lifecycle via `@quenty/playerutils`

**Decision:** Use `RxPlayerUtils.observePlayersBrio()` to track player join/leave and manage profile sessions.

**Rationale:** Brio-based observation gives automatic cleanup when a player leaves, which maps cleanly to calling `Profile:EndSession()`. This is the standard Nevermore pattern for player lifecycle.

**Alternative considered:** Raw `Players.PlayerAdded`/`PlayerRemoving` — rejected because Brio handles edge cases (late connections, maid cleanup) automatically.

### 4. Client data replication via `@quenty/remoting`

**Decision:** Use Remoting to create a RemoteFunction that the client calls to fetch their data, plus a RemoteEvent to push updates.

**Rationale:** Keeps the client lightweight — it requests data once and receives change events. Follows Nevermore's Remoting pattern rather than manual RemoteEvent creation.

### 5. BindToClose handling

**Decision:** Use `@quenty/bindtocloseservice` to register a shutdown callback that ends all active profile sessions.

**Rationale:** ProfileStore already has internal BindToClose handling, but explicitly ending sessions via the service ensures our Maid cleanup runs and any save callbacks fire properly. BindToCloseService integrates with ServiceBag's lifecycle.

## Risks / Trade-offs

- **[Risk] ProfileStore yields on `StartSessionAsync`** → Mitigated by wrapping in a Promise; the service stores pending promises and resolves them when the session starts.
- **[Risk] Profile session stolen by another server** → Mitigated by listening to `Profile.OnSessionEnd` and cleaning up the player's data references. The player will be kicked.
- **[Risk] Studio testing without DataStore access** → Mitigated by ProfileStore's built-in `Mock` support; `PlayerDataService` will use `ProfileStore.Mock` when running in Studio with API access disabled.
- **[Trade-off] Client receives a snapshot, not live updates** → Acceptable for now; the server pushes updates when data changes via `Profile.OnAfterSave`. Real-time per-field observation can be added later.

## Open Questions

- Should the client service expose data as a `ValueObject` or as a plain table with a Changed signal? (Leaning toward `ValueObject` for Rx compatibility.)
