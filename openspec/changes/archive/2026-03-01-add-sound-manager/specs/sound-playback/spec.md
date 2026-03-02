## ADDED Requirements

### Requirement: Play one-shot sound effects
The system SHALL provide a method to play a one-shot (non-looping) sound effect by name. The sound SHALL use the asset ID, volume, and pitch defined in SoundConstants. The Sound instance SHALL be automatically cleaned up after playback completes.

#### Scenario: Play a UI click sound
- **WHEN** client code calls `SoundServiceClient:PlaySound("UIClick")`
- **THEN** a Sound instance is created with the asset ID from SoundConstants for "UIClick", plays once, and is destroyed after completion

#### Scenario: Play sound with invalid name
- **WHEN** client code calls `SoundServiceClient:PlaySound("NonExistent")`
- **THEN** the system SHALL warn (not error) and no sound is played

### Requirement: Play looping background music
The system SHALL provide methods to start and stop looping background music by name. Only one music track SHALL play at a time — starting a new track SHALL stop the current one.

#### Scenario: Start background music
- **WHEN** client code calls `SoundServiceClient:PlayMusic("MainTheme")`
- **THEN** the music track defined in SoundConstants for "MainTheme" SHALL begin playing in a loop

#### Scenario: Switch music tracks
- **WHEN** music "MainTheme" is playing and client code calls `SoundServiceClient:PlayMusic("BattleTheme")`
- **THEN** "MainTheme" SHALL stop and "BattleTheme" SHALL begin playing

#### Scenario: Stop music
- **WHEN** client code calls `SoundServiceClient:StopMusic()`
- **THEN** the currently playing music SHALL stop and no music plays

### Requirement: Sound group volume control
The system SHALL organize sounds into groups (SFX, Music, Ambient) using Roblox SoundGroups. Each group SHALL have independent volume control. All played sounds SHALL be routed to their configured group.

#### Scenario: SFX sound routes to SFX group
- **WHEN** a sound defined with group "SFX" in SoundConstants is played
- **THEN** the Sound instance SHALL be parented under or routed to the SFX SoundGroup

#### Scenario: Music routes to Music group
- **WHEN** background music is started
- **THEN** the Sound instance SHALL be routed to the Music SoundGroup

### Requirement: Sound definitions in shared constants
The system SHALL define all sounds in a shared `SoundConstants` module accessible to both client and server. Each sound entry SHALL include: name (string key), asset ID (number), group (SFX/Music/Ambient), and optional volume and pitch overrides.

#### Scenario: Add a new sound
- **WHEN** a developer adds a new entry to SoundConstants with name "Explosion", asset ID, and group "SFX"
- **THEN** the sound becomes playable via `SoundServiceClient:PlaySound("Explosion")` with no other code changes

### Requirement: Service lifecycle integration
`SoundServiceClient` SHALL be a ServiceBag service with proper `Init` and `Start` methods. It SHALL be registered in `TestQuentyServiceClient`. The server-side `SoundService` SHALL be registered in `TestQuentyService`.

#### Scenario: Client service initialization
- **WHEN** the client ServiceBag initializes
- **THEN** `SoundServiceClient` SHALL register its dependencies and set up sound groups

#### Scenario: Server service initialization
- **WHEN** the server ServiceBag initializes
- **THEN** `SoundService` SHALL initialize without errors
