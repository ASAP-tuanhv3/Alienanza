### Requirement: Coins float up and down
The system SHALL animate all instances tagged `"Coin"` with a continuous vertical floating motion using a sine function on the client side.

#### Scenario: Coin bobs vertically when visible
- **WHEN** a coin tagged `"Coin"` exists in the workspace
- **THEN** the coin's Y position SHALL oscillate sinusoidally around its original position with an amplitude of approximately 0.5 studs

#### Scenario: Animation uses sine function
- **WHEN** the floating animation is running
- **THEN** the Y offset SHALL be calculated as `amplitude * math.sin(tick() * speed + phase)` where speed produces roughly one full cycle every 2 seconds

### Requirement: Animation preserves original position
The system SHALL store each coin's original CFrame on bind and apply the sine offset relative to it, so coins do not drift from their placed position.

#### Scenario: Coin returns to original position at zero crossing
- **WHEN** the sine function crosses zero
- **THEN** the coin's CFrame SHALL equal its original CFrame

### Requirement: Coins animate with different phases
The system SHALL offset each coin's animation phase based on its original position so that multiple coins do not bob in perfect sync.

#### Scenario: Two coins at different positions
- **WHEN** two coins exist at different Y positions
- **THEN** their floating animations SHALL be visually out of phase with each other

### Requirement: Animation stops on coin removal
The system SHALL stop the floating animation and clean up the Heartbeat connection when a coin is destroyed or removed from the workspace.

#### Scenario: Coin is collected
- **WHEN** a coin is collected and destroyed
- **THEN** the Heartbeat connection for that coin SHALL be disconnected and no errors SHALL occur
