## ADDED Requirements

### Requirement: WinZone server-side detection
The system SHALL detect when a player's character touches an instance tagged `WinZone` and notify the player's client of their victory.

#### Scenario: Player touches WinZone
- **WHEN** a player's character part touches an instance tagged `WinZone`
- **THEN** the server SHALL fire a RemoteEvent to that player's client with a "win" payload
- **AND** the server SHALL NOT fire duplicate win events for the same player within the same session

#### Scenario: WinZone binder registration
- **WHEN** TestQuentyService initializes
- **THEN** the `WinZone` binder SHALL be registered via `self._serviceBag:GetService(WinZoneBinder)`

#### Scenario: WinZone binder binds to tagged instances
- **WHEN** an instance with the `WinZone` CollectionService tag exists in the workspace
- **THEN** the WinZone binder SHALL attach and listen for Touched events from Humanoid-containing models

### Requirement: Victory UI on client
The system SHALL display a full-screen victory overlay when the client receives a win notification.

#### Scenario: Victory screen appears
- **WHEN** the client receives the win remote event
- **THEN** a full-screen semi-transparent overlay SHALL appear with a congratulatory message (e.g., "You reached the top!")
- **AND** the overlay SHALL fade in over 0.5 seconds

#### Scenario: Victory screen content
- **WHEN** the victory overlay is displayed
- **THEN** it SHALL show: a title text ("Victory!"), a subtitle ("You conquered the Climbing Level!"), and the player's total collected coin count

#### Scenario: WinConditionServiceClient registration
- **WHEN** TestQuentyServiceClient initializes
- **THEN** `WinConditionServiceClient` SHALL be registered via `self._serviceBag:GetService(require("WinConditionServiceClient"))`

### Requirement: WinCondition constants
The system SHALL define win-condition configuration in a shared constants module `WinConditionConstants`.

#### Scenario: Constants module contents
- **WHEN** requiring WinConditionConstants
- **THEN** it SHALL export `TAG_NAME = "WinZone"` and `REMOTE_EVENT_NAME = "WinConditionNotify"`
