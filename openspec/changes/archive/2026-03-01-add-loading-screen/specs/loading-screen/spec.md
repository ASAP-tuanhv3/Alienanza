## ADDED Requirements

### Requirement: Loading screen displays on join
The system SHALL display a full-screen loading overlay immediately when the client starts, before any game content is visible. The loading screen SHALL replace the default Roblox loading screen by calling `ReplicatedFirst:RemoveDefaultLoadingScreen()`.

#### Scenario: Player joins the game
- **WHEN** the client script starts executing
- **THEN** a full-screen ScreenGui with a solid background SHALL be visible before ServiceBag initialization begins

### Requirement: Status text updates per boot phase
The loading screen SHALL display status text that updates as the client progresses through each boot phase. The phases in order are:
1. "Loading game..." — while `game.Loaded` is awaited
2. "Starting services..." — during ServiceBag Init/Start
3. "Waiting for player data..." — while waiting for `PlayerDataClient` to have non-nil data
4. "Spawning character..." — while waiting for `Players.LocalPlayer.Character`
5. "Finishing up..." — during fade-out

#### Scenario: Boot progresses through phases
- **WHEN** the client transitions from one boot phase to the next
- **THEN** the status text on the loading screen SHALL update to reflect the current phase

#### Scenario: Player data already loaded
- **WHEN** player data is already available when the loading screen checks
- **THEN** the system SHALL skip the "Waiting for player data..." text and proceed to the next phase

#### Scenario: Character already spawned
- **WHEN** the character already exists when the loading screen checks
- **THEN** the system SHALL skip the "Spawning character..." text and proceed to the next phase

### Requirement: Loading screen fade-out on completion
The loading screen SHALL fade out with a smooth transition once all boot phases complete. The fade-out SHALL use a spring-based animation on the background transparency.

#### Scenario: All boot phases complete
- **WHEN** game is loaded, services are started, player data is received, and character has spawned
- **THEN** the loading screen SHALL fade out over approximately 0.5-1 second and then be destroyed

### Requirement: Loading screen service integration
The loading screen SHALL be managed by a `LoadingScreenServiceClient` registered in `TestQuentyServiceClient`. The service SHALL expose methods to update status text and dismiss the screen, allowing the boot sequence in `ClientMain.client.lua` to drive the loading flow.

#### Scenario: Service registration
- **WHEN** `TestQuentyServiceClient.Init` runs
- **THEN** `LoadingScreenServiceClient` SHALL be registered via `serviceBag:GetService()`

#### Scenario: Boot sequence drives loading screen
- **WHEN** `ClientMain.client.lua` executes the boot sequence
- **THEN** it SHALL call `LoadingScreenServiceClient` methods to update status and dismiss the screen at appropriate points

### Requirement: Loading screen UI layout
The loading screen SHALL display:
- A full-screen solid background (dark color)
- The game title centered in the upper portion
- Status text centered below the title
- A simple loading indicator (spinner or animated dots)

#### Scenario: Visual layout
- **WHEN** the loading screen is visible
- **THEN** it SHALL cover the entire viewport with a dark background, show the game title, status text, and a loading indicator
