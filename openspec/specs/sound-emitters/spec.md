## ADDED Requirements

### Requirement: Binder-based positional sound emitters
The system SHALL provide a `SoundEmitter` binder that attaches to Roblox instances tagged with "SoundEmitter" via CollectionService. The binder SHALL create a Sound instance parented to the tagged instance for positional/spatial audio.

#### Scenario: Tagged part plays positional sound
- **WHEN** a Part in the workspace has the CollectionService tag "SoundEmitter" and attribute `SoundName` set to "Waterfall"
- **THEN** a Sound instance SHALL be created as a child of that Part, configured with the "Waterfall" definition from SoundConstants, and SHALL play as a looping positional sound

#### Scenario: Tag removed stops sound
- **WHEN** the "SoundEmitter" tag is removed from a Part that has an active sound emitter
- **THEN** the Sound instance SHALL stop playing and be cleaned up via Maid

### Requirement: Sound emitter configuration via attributes
The `SoundEmitter` binder SHALL read configuration from instance attributes: `SoundName` (string, required), `Volume` (number, optional override), and `Looped` (boolean, optional override, defaults to true).

#### Scenario: Custom volume override
- **WHEN** a tagged instance has attribute `SoundName` = "Wind" and `Volume` = 0.3
- **THEN** the sound SHALL play at volume 0.3 regardless of the default volume in SoundConstants

#### Scenario: Non-looping emitter
- **WHEN** a tagged instance has attribute `SoundName` = "DoorCreak" and `Looped` = false
- **THEN** the sound SHALL play once and stop (not loop)

### Requirement: Sound emitter routes to Ambient group
All sounds created by `SoundEmitter` SHALL be routed to the Ambient SoundGroup by default, unless the sound definition in SoundConstants specifies a different group.

#### Scenario: Ambient group routing
- **WHEN** a SoundEmitter plays a sound with no explicit group override
- **THEN** the Sound instance SHALL be routed to the Ambient SoundGroup

### Requirement: Binder registration in client service
The `SoundEmitter` binder SHALL be registered in `SoundServiceClient.Init` using the standard Nevermore binder registration pattern.

#### Scenario: Binder active after service start
- **WHEN** the client ServiceBag has started
- **THEN** any instances in the workspace with the "SoundEmitter" tag SHALL have the binder attached and sounds playing
