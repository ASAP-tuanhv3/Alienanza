## Requirements

### Requirement: Player data template definition
The system SHALL define a `PlayerDataConstants` module in Shared containing the default data template table and the DataStore name string. The template SHALL be a plain Luau table with no userdata, functions, or Instance references.

#### Scenario: Constants module provides template
- **WHEN** any module requires `PlayerDataConstants`
- **THEN** it SHALL receive a table with a `TEMPLATE` field (the default data table) and a `STORE_NAME` field (string)

#### Scenario: Template contains default values
- **WHEN** a new player profile is created
- **THEN** the profile data SHALL match the structure defined in `PlayerDataConstants.TEMPLATE`

### Requirement: Profile session lifecycle management
The system SHALL provide a `PlayerDataService` that automatically starts a ProfileStore session when a player joins and ends the session when the player leaves. The service SHALL follow ServiceBag Init/Start lifecycle.

#### Scenario: Player joins and profile loads
- **WHEN** a player joins the server
- **THEN** `PlayerDataService` SHALL call `ProfileStore:StartSessionAsync()` with the player's UserId as the key
- **AND** call `Profile:AddUserId()` with the player's UserId
- **AND** call `Profile:Reconcile()` to fill missing template fields

#### Scenario: Player leaves and session ends
- **WHEN** a player leaves the server
- **THEN** `PlayerDataService` SHALL call `Profile:EndSession()` for that player's profile
- **AND** clean up all associated resources via Maid

#### Scenario: Profile session stolen by another server
- **WHEN** `Profile.OnSessionEnd` fires while the player is still connected
- **THEN** `PlayerDataService` SHALL kick the player with an appropriate message
- **AND** clean up all associated resources

#### Scenario: Server shutdown
- **WHEN** the server shuts down (BindToClose)
- **THEN** `PlayerDataService` SHALL end all active profile sessions before the server closes

### Requirement: Promise-based profile access
The system SHALL expose a `PromisePlayerProfile(player)` method that returns a Promise resolving to the player's active Profile object.

#### Scenario: Profile already loaded
- **WHEN** `PromisePlayerProfile` is called for a player whose profile is loaded
- **THEN** the Promise SHALL resolve immediately with the Profile

#### Scenario: Profile still loading
- **WHEN** `PromisePlayerProfile` is called while the profile is still loading
- **THEN** the Promise SHALL resolve once the profile finishes loading

#### Scenario: Profile failed to load
- **WHEN** `PromisePlayerProfile` is called for a player whose profile failed to load
- **THEN** the Promise SHALL reject with an error message

#### Scenario: Player already left
- **WHEN** `PromisePlayerProfile` is called for a player who has already left
- **THEN** the Promise SHALL reject

### Requirement: Client data replication
The system SHALL provide a `PlayerDataClient` service that receives the local player's data from the server and exposes it for observation.

#### Scenario: Client requests data
- **WHEN** `PlayerDataClient` starts
- **THEN** it SHALL request the local player's data from the server via Remoting

#### Scenario: Server pushes data updates
- **WHEN** the server saves the player's profile data
- **THEN** the server SHALL send the updated data to that player's client via Remoting

#### Scenario: Client observes data
- **WHEN** a client module calls `PlayerDataClient:ObserveData()`
- **THEN** it SHALL receive an Observable that emits the current data and subsequent updates

### Requirement: Studio mock support
The system SHALL use ProfileStore's mock DataStore when running in Roblox Studio without API access, so that development and testing work without live DataStore calls.

#### Scenario: Running in Studio
- **WHEN** the game is running in Studio (not a live server)
- **THEN** `PlayerDataService` SHALL use `ProfileStore.Mock` instead of the real ProfileStore
- **AND** all profile operations SHALL function identically using mock data

### Requirement: Service registration
`PlayerDataService` SHALL be registered in `TestQuentyService.Init()` and `PlayerDataClient` SHALL be registered in `TestQuentyServiceClient.Init()`.

#### Scenario: Server bootstrap
- **WHEN** the server starts and `TestQuentyService:Init()` runs
- **THEN** `PlayerDataService` SHALL be registered via `serviceBag:GetService()`

#### Scenario: Client bootstrap
- **WHEN** the client starts and `TestQuentyServiceClient:Init()` runs
- **THEN** `PlayerDataClient` SHALL be registered via `serviceBag:GetService()`
