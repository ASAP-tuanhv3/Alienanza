### Requirement: Platform moves between waypoints
The system SHALL move any instance tagged `MovingPlatform` between waypoint positions defined as Vector3 attributes (`Waypoint1`, `Waypoint2`, ...) on the instance. The platform's starting position is its initial CFrame (implicit Waypoint0). Movement SHALL loop continuously: Waypoint0 → Waypoint1 → ... → WaypointN → Waypoint0 → ...

#### Scenario: Platform with one waypoint moves back and forth
- **WHEN** a platform tagged `MovingPlatform` has attribute `Waypoint1 = Vector3.new(0, 10, 0)`
- **THEN** the platform SHALL tween from its start position to `Waypoint1` and back, repeating indefinitely

#### Scenario: Platform with multiple waypoints follows full path
- **WHEN** a platform has `Waypoint1`, `Waypoint2`, and `Waypoint3` attributes
- **THEN** the platform SHALL visit each waypoint in order (start → 1 → 2 → 3 → start → 1 → ...) continuously

#### Scenario: Platform with no waypoints stays still
- **WHEN** a platform tagged `MovingPlatform` has no `Waypoint*` attributes
- **THEN** the platform SHALL remain stationary

### Requirement: Configurable speed per platform
The system SHALL move platforms at a speed defined by the `Speed` number attribute on the instance. If no `Speed` attribute exists, the platform SHALL use the default speed from `MovingPlatformConstants.SPEED` (8 studs/second).

#### Scenario: Custom speed attribute
- **WHEN** a platform has attribute `Speed = 4`
- **THEN** the platform SHALL move at 4 studs/second between waypoints

#### Scenario: Default speed
- **WHEN** a platform has no `Speed` attribute
- **THEN** the platform SHALL move at 8 studs/second

### Requirement: Pause at waypoints
The system SHALL pause the platform at each waypoint for a duration defined by the `PauseDuration` number attribute (seconds). If no attribute exists, the default from `MovingPlatformConstants.PAUSE_DURATION` (1 second) SHALL be used.

#### Scenario: Custom pause duration
- **WHEN** a platform has attribute `PauseDuration = 2`
- **THEN** the platform SHALL wait 2 seconds at each waypoint before moving to the next

#### Scenario: Zero pause
- **WHEN** a platform has attribute `PauseDuration = 0`
- **THEN** the platform SHALL immediately begin moving to the next waypoint with no delay

### Requirement: Player rides moving platform
The system SHALL keep players standing on a moving platform attached to it, so the player moves with the platform without sliding off.

#### Scenario: Player stands on platform
- **WHEN** a player's character is standing on a moving platform
- **THEN** the player's character SHALL move with the platform as it travels between waypoints

#### Scenario: Player jumps off platform
- **WHEN** a player jumps while on a moving platform
- **THEN** the player SHALL detach from the platform and follow normal physics

### Requirement: Server binder registered via TestQuentyService
The `MovingPlatform` server binder SHALL be registered in `TestQuentyService.Init` using the Binder pattern, consistent with existing binders (Coin, SpikeBlock).

#### Scenario: Binder activates on tagged instance
- **WHEN** an instance receives the `MovingPlatform` CollectionService tag
- **THEN** the server binder SHALL create a `MovingPlatform` object and begin movement

#### Scenario: Binder cleans up on tag removal
- **WHEN** the `MovingPlatform` tag is removed from an instance
- **THEN** the binder SHALL stop the tween and clean up resources

### Requirement: Client binder registered via TestQuentyServiceClient
The `MovingPlatformClient` client binder SHALL be registered in `TestQuentyServiceClient.Init` for client-side player attachment logic.

#### Scenario: Client binder tracks platform under player
- **WHEN** the client detects the local player standing on a tagged `MovingPlatform` instance
- **THEN** the client binder SHALL apply frame-by-frame CFrame delta compensation to the player's character

### Requirement: All block-moving models placed in TestArena
All three block-moving asset variants (`block-moving`, `block-moving-blue`, `block-moving-large`) SHALL be placed in the TestArena workspace with the `MovingPlatform` tag and at least one waypoint attribute configured.

#### Scenario: Block-moving models are present and functional
- **WHEN** the game starts
- **THEN** the TestArena SHALL contain instances of `block-moving`, `block-moving-blue`, and `block-moving-large`, each tagged `MovingPlatform` and moving between configured waypoints
