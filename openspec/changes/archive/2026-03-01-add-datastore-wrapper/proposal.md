## Why

The project needs persistent player data storage (e.g., currency, inventory, settings). ProfileStore has already been added to the codebase (`src/modules/Server/ProfileStore.luau`) and provides session-locking, auto-saving, and GDPR-compliant data management. A Nevermore-style service wrapper is needed to integrate ProfileStore into the ServiceBag architecture, giving other services a clean API for reading/writing player data.

## What Changes

- Add a `PlayerDataService` that wraps ProfileStore with ServiceBag lifecycle (Init/Start), manages profile sessions per player, and exposes a promise-based API for accessing player data
- Add a `PlayerDataConstants` module defining the default data template and store configuration
- Add a `PlayerDataClient` client service that receives replicated player data and exposes observable state to UI

## Nevermore Packages

Relevant packages already installed:
- `@quenty/servicebag` — DI container for service registration
- `@quenty/maid` — Cleanup management for player session lifecycles
- `@quenty/baseobject` — Base class for potential data wrapper objects

Relevant packages to consider installing:
- `@quenty/playerutils` — Player join/leave utilities (`RxPlayerUtils`)
- `@quenty/rx` — Reactive observables for data change streams
- `@quenty/valueobject` — Observable value containers for replicated data
- `@quenty/remoting` — Client-server communication for data replication
- `@quenty/bindtocloseservice` — Ensures profiles save on server shutdown

The existing `@quenty/datastore` package provides an alternative DataStore wrapper, but the user has chosen ProfileStore for its session-locking model and API. This wrapper will use ProfileStore directly rather than `@quenty/datastore`.

## Capabilities

### New Capabilities
- `player-data`: Server-side player data management via ProfileStore — session lifecycle, data access API, auto-save, and client replication

### Modified Capabilities

_None._

## Impact

- **New files**: `PlayerDataService.lua`, `PlayerDataConstants.lua`, `PlayerDataClient.lua`, plus test specs
- **Modified files**: `TestQuentyService.lua` (register `PlayerDataService`), `TestQuentyServiceClient.lua` (register `PlayerDataClient`)
- **Dependencies**: ProfileStore.luau (already added), potentially new `@quenty/*` packages listed above
- **Runtime**: ProfileStore will make DataStore API calls — requires DataStore access in live/Studio with API services enabled
