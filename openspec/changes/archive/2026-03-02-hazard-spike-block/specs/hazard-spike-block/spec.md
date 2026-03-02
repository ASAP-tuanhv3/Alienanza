## ADDED Requirements

### Requirement: Spike-block damages player on contact

The system SHALL deal damage to a player's Humanoid when their character touches a part tagged with `"SpikeBlock"`. The damage amount SHALL be defined in `SpikeBlockConstants.DAMAGE` (default: 25 HP).

#### Scenario: Player walks into spike-block

- **WHEN** a player's character touches a SpikeBlock-tagged part
- **THEN** the server SHALL call `Humanoid:TakeDamage(SpikeBlockConstants.DAMAGE)` on the player's humanoid

#### Scenario: Non-player instance touches spike-block

- **WHEN** a non-player instance (e.g., a dropped tool or NPC) touches a SpikeBlock-tagged part
- **THEN** the system SHALL ignore the touch and take no action

### Requirement: Invincibility frames after damage

The system SHALL grant the player invincibility frames (i-frames) for `SpikeBlockConstants.IFRAME_DURATION` seconds (default: 1.5s) after taking spike damage. During i-frames, the player SHALL NOT take damage from any spike-block.

#### Scenario: Player touches spike-block during i-frames

- **WHEN** a player takes spike damage
- **AND** the player touches any SpikeBlock-tagged part within 1.5 seconds
- **THEN** the system SHALL NOT deal additional damage

#### Scenario: Player touches spike-block after i-frames expire

- **WHEN** a player takes spike damage
- **AND** the player touches a SpikeBlock-tagged part after 1.5 seconds have elapsed
- **THEN** the system SHALL deal damage normally and grant new i-frames

### Requirement: Client receives damage notification

The server SHALL fire a remote event to the damaged player when spike damage is dealt. The client SHALL use this event to trigger visual and audio feedback.

#### Scenario: Player takes spike damage

- **WHEN** the server deals spike damage to a player
- **THEN** the server SHALL fire `SpikeBlockConstants.REMOTE_EVENT_NAME` to that player with the damage amount

### Requirement: Damage sound plays on hit

The client SHALL play a damage sound effect when receiving a spike damage notification.

#### Scenario: Damage notification received

- **WHEN** the client receives a spike damage remote event
- **THEN** the client SHALL play the `"SpikeBlockHit"` sound defined in `SoundConstants`

### Requirement: Character flashes during i-frames

The client SHALL apply a visual flash effect to the player's character for the duration of i-frames. The flash SHALL toggle character part transparency every 0.15 seconds.

#### Scenario: Flash effect during i-frames

- **WHEN** the client receives a spike damage notification
- **THEN** the client SHALL toggle the character's BasePart transparency between 0 and 0.5 every 0.15 seconds for `SpikeBlockConstants.IFRAME_DURATION` seconds
- **AND** restore all parts to their original transparency when i-frames end

#### Scenario: Player takes damage again during flash

- **WHEN** the player takes spike damage while an existing flash effect is active
- **THEN** the system SHALL restart the flash timer from the beginning

### Requirement: Spike-block instances in test arena

The test arena SHALL contain spike-block parts tagged with `"SpikeBlock"` for gameplay testing.

#### Scenario: Spike-blocks present in workspace

- **WHEN** the game loads
- **THEN** there SHALL be at least one part in the workspace tagged with `"SpikeBlock"`
