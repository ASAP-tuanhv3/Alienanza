# Nevermore Package Catalog

Reference of all available `@quenty/*` packages for use during proposal evaluation.
Install via: `pnpm install @quenty/<package-name>`

## Core / Infrastructure

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| loader | Module loader, require-by-name | loader, LoaderLink, PackageTracker, Replicator, ReplicationType |
| servicebag | Dependency injection container | ServiceBag, ServiceInitLogger |
| binder | Attach behavior to instances via CollectionService tags | Binder, BinderGroup, BinderGroupProvider, BinderProvider, BinderUtils, BoundAncestorTracker, BoundChildCollection, BoundParentTracker |
| maid | Cleanup/destructor utility | Maid, MaidTaskUtils |
| baseobject | Base class with Maid integration | BaseObject |
| signal | Custom signal/event implementation | Signal, SignalUtils, EventHandlerUtils |
| promise | Promise/async utility | Promise, PromiseUtils, PromiseInstanceUtils, PendingPromiseTracker |
| promisemaid | Promise + Maid integration | PromiseMaidUtils |
| rx | Reactive observables | Rx, Observable, ObservableSubscriptionTable |
| rxbinderutils | Rx utilities for binders | RxBinderUtils, RxBinderGroupUtils |
| rxsignal | Rx wrapper for signals | RxSignal |
| blend | Reactive UI framework | Blend, SpringObject |
| brio | Lifecycle-scoped value wrapper | Brio, BrioUtils, RxBrioUtils |
| valueobject | Observable value container | ValueObject, ValueObjectUtils |
| singleton | Singleton pattern utility | Singleton |
| tie | Interface-based programming | TieDefinition, TieImplementation, TieInterface, TieRealmService |
| rogue-properties | Dynamic property system | RogueProperty, RoguePropertyService, RogueAdditive, RogueMultiplier, RogueSetter |
| rogue-humanoid | Humanoid extensions | RogueHumanoid, RogueHumanoidService, RogueHumanoidServiceClient |

## Data / Persistence

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| datastore | DataStore wrapper with queuing/retry | DataStore, DataStoreStage, DataStoreWriter, DataStorePromises, GameDataStoreService, PlayerDataStoreService |
| memorystoreutils | MemoryStore utilities | MemoryStoreUtils |
| secrets | Secret management | SecretsService, SecretsServiceClient, SecretsCommandService |
| settings | Settings/configuration system | SettingsService, SettingsServiceClient, SettingDefinition, SettingProperty, PlayerSettings |
| settings-inputkeymap | Input keymap settings | SettingsInputKeyMapService, SettingsInputKeyMapServiceClient, InputKeyMapSetting |
| lrucache | LRU cache implementation | LRUCache |
| jsonutils | JSON utilities | JSONUtils |

## Player / Character

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| playerutils | Player utility functions | PlayerUtils, RxPlayerUtils |
| playerbinder | Bind behavior to players | PlayerBinder |
| playerhumanoidbinder | Bind behavior to player humanoids | PlayerHumanoidBinder, PlayerCharacterBinder |
| playerinputmode | Detect player input mode | PlayerInputModeService, PlayerInputModeServiceClient, PlayerInputModeTypes |
| playersservicepromises | Promise-based Players service | PlayersServicePromises |
| playerthumbnailutils | Player thumbnail utilities | PlayerThumbnailUtils |
| characterutils | Character utility functions | CharacterUtils, CharacterPromiseUtils, RxCharacterUtils, RootPartUtils |
| humanoidutils | Humanoid utilities | HumanoidUtils, RxHumanoidUtils |
| humanoidtracker | Track humanoid state | HumanoidTracker, HumanoidTrackerService |
| humanoidspeed | Humanoid speed management | HumanoidSpeed, HumanoidSpeedClient |
| humanoidanimatorutils | Humanoid animator utilities | HumanoidAnimatorUtils |
| humanoiddescriptionutils | HumanoidDescription utilities | HumanoidDescriptionUtils |
| humanoidkillerutils | Kill attribution | HumanoidKillerUtils |
| humanoidmovedirectionutils | Move direction utilities | HumanoidMoveDirectionUtils |
| humanoidteleportutils | Teleport humanoid | HumanoidTeleportUtils |
| r15utils | R15 rig utilities | R15Utils, RxR15Utils |
| bodycolorsutils | Body color utilities | BodyColorsDataUtils, BodyColorsDataConstants |
| avatareditorutils | Avatar editor utilities | AvatarEditorUtils, AvatarEditorInventory |
| equippedtracker | Track equipped tools | EquippedTracker |
| clipcharacters | Clip characters through parts | ClipCharacters, ClipCharactersService, ClipCharactersServiceClient |
| firstpersoncharactertransparency | First-person transparency | HideHead, ShowBody |

## Camera

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| camera | Camera system | CameraStack, CameraStackService, CameraControls, CameraFrame, CameraState, DefaultCamera, FadeBetweenCamera, SmoothRotatedCamera, ZoomedCamera |
| camerainfo | Camera info utilities | CameraInfoUtils |
| camerastoryutils | Camera story utilities | CameraStoryUtils |
| depthoffield | Depth of field effects | DepthOfFieldEffect |

## Animation

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| animations | Animation management | AnimationUtils, AnimationSlotPlayer, AnimationTrackPlayer, AnimationPromiseUtils |
| animationgroup | Animation group system | AnimationGroup, AnimationGroupUtils |
| animationprovider | Animation provider service | AnimationProvider |
| animationtrackutils | AnimationTrack utilities | AnimationTrackUtils |

## Physics / Math

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| spring | Spring/PID physics | Spring, SpringUtils, LinearValue |
| acceltween | Acceleration-based tweening | AccelTween |
| timedtween | Time-based tweening | TimedTween |
| trajectory | Trajectory calculation | trajectory, MinEntranceVelocityUtils |
| kinematics | Kinematics utilities | Kinematics, KinematicUtils |
| ik | Inverse kinematics | IKService, IKServiceClient, IKRig, IKRigClient, ArmIKBase |
| cframeutils | CFrame math utilities | CFrameUtils |
| vector3utils | Vector3 utilities | Vector3Utils, RandomVector3Utils |
| vector3int16utils | Vector3int16 utilities | Vector3int16Utils |
| quaternion | Quaternion math | Quaternion, QuaternionObject |
| qframe | Quaternion-based CFrame | QFrame |
| bezierutils | Bezier curve utilities | BezierUtils |
| cubicspline | Cubic spline interpolation | CubicSplineUtils, CubicTweenUtils |
| geometryutils | Geometry calculations | CircleUtils, PlaneUtils, ScaleModelUtils, OrthogonalUtils |
| convexhull | Convex hull computation | ConvexHull2DUtils, ConvexHull3DUtils |
| linearsystemssolver | Linear systems solver | LinearSystemsSolverUtils |
| polynomialutils | Polynomial utilities | PolynomialUtils |
| math | Extended math utilities | Math |
| axisangleutils | Axis-angle rotation utilities | AxisAngleUtils |
| numberrangeutils | NumberRange utilities | NumberRangeUtils |
| numbersequenceutils | NumberSequence utilities | NumberSequenceUtils |
| binarysearch | Binary search algorithm | BinarySearchUtils |

## UI / GUI

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| basicpane | Base UI pane class | BasicPane, BasicPaneUtils |
| scrollingframe | Enhanced ScrollingFrame | ScrollingFrame, ScrollModel, Scrollbar |
| snackbar | Snackbar/toast notifications | Snackbar, SnackbarService, SnackbarServiceClient |
| guitriangle | GUI triangle rendering | GuiTriangle |
| pillbacking | Pill-shaped UI backing | PillBackingBuilder, PillBackingUtils |
| roundedbackingbuilder | Rounded UI backing | RoundedBackingBuilder |
| buttonutils | Button utilities | ButtonUtils |
| buttondragmodel | Button drag behavior | ButtonDragModel |
| buttonhighlightmodel | Button highlight behavior | ButtonHighlightModel, HandleHighlightModel |
| rotatinglabel | Rotating text label | RotatingLabel, RotatingLabelBuilder, RotatingCharacter |
| countdowntext | Countdown display | CountdownTextUtils |
| richtext | Rich text utilities | RichTextUtils |
| markdownrender | Markdown rendering | MarkdownParser, MarkdownRender |
| colorpicker | Color picker UI | ColorPickerTriangle, HSColorPicker, HSVColorPicker |
| radial-image | Radial image display | RadialImage |
| sprites | Sprite sheet utilities | Sprite, Spritesheet |
| textboxutils | TextBox utilities | RxTextBoxUtils |
| selectionutils | GuiObject selection utilities | RxSelectionUtils |
| selectionimageutils | Selection image utilities | SelectionImageUtils |
| uiobjectutils | UI object utilities | GuiInteractionUtils, PlayerGuiUtils, ScrollingDirectionUtils |
| ultrawidecontainerutils | Ultrawide display support | UltrawideContainerUtils |
| flipbook | Flipbook animation | Flipbook, FlipbookLibrary, FlipbookPlayer |
| genericscreenguiprovider | ScreenGui provider | GenericScreenGuiProvider, ScreenGuiService |
| guivisiblemanager | GUI visibility management | GuiVisibleManager |

## Input

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| inputmode | Input mode detection (keyboard/gamepad/touch) | InputMode, InputModeServiceClient, InputModeType, InputModeTypes |
| inputkeymaputils | Input key mapping | InputKeyMap, InputKeyMapList, InputKeyMapService, InputKeyMapServiceClient |
| inputobjectutils | InputObject utilities | InputObjectUtils, InputObjectTracker, RxInputObjectUtils |
| jumpbuttonutils | Jump button utilities | JumpButtonUtils |
| mouseshiftlockservice | Mouse shift lock | MouseShiftLockService |
| mouseovermixin | Mouseover detection mixin | MouseOverMixin |
| multipleclickutils | Multi-click detection | MultipleClickUtils |
| hapticfeedbackutils | Haptic feedback | HapticFeedbackUtils |
| numbertoinputkeyutils | Number to input key mapping | NumberToInputKeyUtils |

## Networking / Remoting

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| remoting | Network remoting framework | Remoting, RemotingMember, GetRemoteEvent, GetRemoteFunction |
| remotefunctionutils | RemoteFunction utilities | RemoteFunctionUtils |
| networkownerservice | Network owner management | NetworkOwnerService |
| networkownerutils | Network owner utilities | NetworkOwnerUtils |
| networkropeutils | Network rope utilities | NetworkRopeUtils |
| messagingserviceutils | MessagingService utilities | MessagingServiceUtils, PlaceMessagingService |
| httppromise | HTTP request promises | HttpPromise |
| influxdbclient | InfluxDB client | InfluxDBClient, InfluxDBPoint, InfluxDBWriteAPI |

## Services / Systems

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| cmdrservice | In-game command system (Cmdr) | CmdrService, CmdrServiceClient, CmdrCommandDefinitionTemplate |
| clienttranslator | Client-side i18n/localization | JSONTranslator, LocalizationServiceUtils, TranslatorService |
| templateprovider | Template/prefab provider | TemplateProvider, TaggedTemplateProvider, ModuleProvider |
| gameproductservice | Game product/monetization | GameProductService, GameProductServiceClient, PlayerProductManager |
| receiptprocessing | Receipt processing for purchases | ReceiptProcessingService |
| idleservice | Player idle detection | IdleService, IdleServiceClient |
| resetservice | Character reset service | ResetService, ResetServiceClient |
| softshutdown | Graceful server shutdown | SoftShutdownService, SoftShutdownServiceClient |
| teleportserviceutils | TeleportService utilities | TeleportServiceUtils, RxTeleportUtils |
| bindtocloseservice | BindToClose management | BindToCloseService |
| permissionprovider | Permission system | PermissionService, PermissionServiceClient, PermissionLevel, GroupPermissionProvider |
| textfilterservice | Text filtering service | TextFilterService, TextFilterServiceClient |
| textfilterutils | Text filtering utilities | TextFilterUtils |
| chatproviderservice | Chat provider | ChatProviderService, ChatProviderServiceClient, ChatTag, HasChatTags |
| voicechat | Voice chat utilities | VoiceChatUtils |
| scoredactionservice | Scored action prioritization | ScoredActionService, ScoredActionServiceClient, ScoredAction, ScoredActionPicker |
| screenshothudservice | Screenshot HUD | ScreenshotHudServiceClient, ScreenshotHudModel |
| timesyncservice | Time synchronization | TimeSyncService, MasterClock, SlaveClock |
| coreguienabler | CoreGui toggle | CoreGuiEnabler |
| coreguiutils | CoreGui utilities | CoreGuiUtils |
| spawning | Spawn management | SpawnService, SpawnServiceClient, SpawnerUtils |

## Collections / Data Structures

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| observablecollection | Observable collections (list, map, set) | ObservableList, ObservableMap, ObservableMapSet, ObservableSet, ObservableSortedList, ObservableCountingMap |
| octree | Octree spatial data structure | Octree, OctreeNode |
| queue | Queue data structure | Queue |
| statestack | State stack | StateStack, RxStateStackUtils |
| table | Table utilities | Table, Set |
| tuple | Tuple utilities | Tuple, TupleLookup |
| optional | Optional/Maybe type | optional |
| undostack | Undo/redo stack | UndoStack |
| counter | Counter utility | Counter |
| aggregator | Value aggregation | Aggregator, RateAggregator |

## Instance / Object Utilities

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| instanceutils | Instance utility functions | RxInstanceUtils |
| attributeutils | Instance attribute utilities | AttributeUtils, AttributeValue, RxAttributeUtils, JSONAttributeValue |
| collectionserviceutils | CollectionService utilities | CollectionServiceUtils, RxCollectionServiceUtils |
| weldconstraintutils | WeldConstraint utilities | WeldConstraintUtils |
| motor6d | Motor6D utilities | Motor6DService, Motor6DStack, Motor6DStackHumanoid, Motor6DAnimator |
| setmechanismcframe | Set mechanism CFrame | setMechanismCFrame |
| getmechanismparts | Get mechanism parts | getMechanismParts |
| meshutils | Mesh utilities | MeshUtils |
| adorneeutils | Adornee utilities | AdorneeUtils |
| adorneedata | Adornee data | AdorneeData, AdorneeDataEntry, AdorneeDataValue |
| adorneeboundingbox | Adornee bounding box | AdorneeBoundingBox, AdorneeModelBoundingBox, AdorneePartBoundingBox |
| adorneevalue | Adornee value | AdorneeValue |
| rigbuilderutils | Rig building utilities | RigBuilderUtils |
| seatutils | Seat utilities | SeatUtils, RxSeatUtils |
| toolutils | Tool utilities | ToolUtils, RxToolUtils |
| applytagtotaggedchildren | Tag propagation | ApplyTagToTaggedChildren |
| propertyvalue | Property value tracking | PropertyValue |
| overriddenproperty | Property override utility | OverriddenProperty |
| preferredparentutils | Preferred parent utilities | PreferredParentUtils |
| linkutils | ObjectValue link utilities | LinkUtils, RxLinkUtils |
| boundlinkutils | Bound link utilities | BoundLinkCollection, BoundLinkUtils, promiseBoundLinkedClass |
| safedestroy | Safe instance destruction | safeDestroy |
| hide | Instance hiding utility | Hide, HideService, HideServiceClient, DynamicHide |
| highlight | Instance highlight | AnimatedHighlight, AnimatedHighlightModel, HighlightServiceClient |

## World / Environment

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| draw | Debug drawing utilities | Draw |
| particleengine | GUI-based particle engine | ParticleEngineClient, ParticleEngineServer |
| particles | Particle utilities | ParticleEmitterUtils |
| characterparticleplayer | Character particle effects | ParticlePlayer |
| terrainutils | Terrain utilities | TerrainUtils |
| region3utils | Region3 utilities | Region3Utils |
| region3int16utils | Region3int16 utilities | Region3int16Utils |
| getgroundplane | Ground plane detection | getGroundPlane, batchRaycast |
| sunpositionutils | Sun position calculation | SunPositionUtils |
| fakeskybox | Fake skybox | FakeSkybox |
| streamingutils | Streaming utilities | StreamingUtils |
| boundingboxutils | Bounding box utilities | BoundingBoxUtils, CompiledBoundingBoxUtils |
| raycaster | Raycasting utilities | Raycaster, RaycastUtils |
| parttouchingcalculator | Part touching detection | PartTouchingCalculator, BinderTouchingCalculator |
| touchingpartutils | Touching part utilities | TouchingPartUtils |
| viewport | Viewport utilities | Viewport, ViewportControls |
| transparencyservice | Transparency management | TransparencyService |
| modeltransparencyeffect | Model transparency effects | ModelTransparencyEffect |
| modelappearance | Model appearance management | ModelAppearance |
| pathfindingutils | Pathfinding utilities | PathfindingUtils |

## Sound

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| sounds | Sound utilities | SoundUtils, SoundPromiseUtils |
| soundplayer | Sound playback | LoopedSoundPlayer, SimpleLoopedSoundPlayer, SoundPlayerServiceClient, SoundPlayerStack, LayeredLoopedSoundPlayer |
| soundgroup | Sound group management | SoundEffectService, SoundGroupService, SoundGroupServiceClient, SoundGroupTracker, SoundGroupVolume, WellKnownSoundGroups |

## Social / Teams

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| teamtracker | Team tracking | TeamTracker |
| teamutils | Team utilities | TeamUtils, RxTeamUtils |
| friendutils | Friend utilities | FriendUtils, RxFriendUtils |
| socialserviceutils | SocialService utilities | SocialServiceUtils |
| elo | ELO rating system | EloUtils, EloMatchResult |

## Monetization / Products

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| marketplaceutils | MarketplaceService utilities | MarketplaceUtils, MarketplaceServiceCache |
| assetserviceutils | AssetService utilities | AssetServiceUtils, AssetServiceCache |
| badgeutils | Badge utilities | BadgeUtils |
| policyserviceutils | PolicyService utilities | PolicyServiceUtils |
| gameconfig | Game configuration | GameConfig, GameConfigService, GameConfigServiceClient, GameConfigAsset |
| gamescalingutils | Game scaling utilities | GameScalingUtils, GameScalingHelper |
| gameversionutils | Game version utilities | GameVersionUtils |
| insertserviceutils | InsertService utilities | InsertServiceUtils |
| rbxasset | Roblox asset URL utilities | RbxAssetUtils |
| rbxthumb | Roblox thumbnail URL utilities | RbxThumbUtils, RbxThumbnailTypes |
| accessorytypeutils | Accessory type utilities | AccessoryTypeUtils |
| ugcsanitize | UGC sanitization | DisableHatParticles |

## Utility / Misc

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| string | String utilities | String |
| utf8 | UTF-8 utilities | UTF8 |
| typeutils | Type checking utilities | TypeUtils |
| ducktype | Duck typing utilities | DuckTypeUtils |
| symbol | Symbol creation | Symbol |
| enums | Custom enum utilities | SimpleEnum |
| enumutils | Enum utilities | EnumUtils |
| functionutils | Function utilities | FunctionUtils |
| memoize | Memoization | MemorizeUtils |
| debounce | Debounce utility | debounce, DebounceTimer |
| throttle | Throttle utility | throttle, ThrottledFunction |
| cooldown | Cooldown system | Cooldown, CooldownService, CooldownServiceClient, CooldownTracker, CooldownModel |
| deferred | Deferred execution | deferred |
| cancellabledelay | Cancellable delay | cancellableDelay |
| canceltoken | Cancellation token | CancelToken |
| enabledmixin | Enabled state mixin | EnabledMixin |
| generatewithmixin | Mixin generation | GenerateWithMixin |
| isamixin | Mixin type checking | IsAMixin |
| defaultvalueutils | Default value utilities | DefaultValueUtils |
| probability | Probability utilities | Probability |
| randomutils | Random utilities | RandomUtils, RandomSampler |
| funnels | Analytics funnels | FunnelStepLogger, FunnelStepTracker |
| metricutils | Metrics utilities | MetricUtils |
| performanceutils | Performance utilities | PerformanceUtils |
| steputils | RunService step utilities | StepUtils, onRenderStepFrame, onSteppedFrame |
| time | Time utilities | Time |
| lipsum | Lorem ipsum generator | LipsumUtils, LipsumIconUtils |
| pagesutils | Pages object utilities | PagesUtils, PagesProxy, PagesDatabase |
| localizedtextutils | Localized text utilities | LocalizedTextUtils |
| pseudolocalize | Pseudo-localization for testing | PseudoLocalize |
| color3utils | Color3 utilities | Color3Utils, LuvColor3Utils |
| color3serializationutils | Color3 serialization | Color3SerializationUtils |
| colorpalette | Color palette | ColorPalette, ColorGradePalette, FontPalette |
| colorsequenceutils | ColorSequence utilities | ColorSequenceUtils |
| cframeserializer | CFrame serialization | CFrameSerializer |
| rectutils | Rect utilities | RectUtils |
| valuebaseutils | ValueBase utilities | ValueBaseUtils, RxValueBaseUtils, ValueBaseValue |
| userserviceutils | UserService utilities | UserServiceUtils, UserInfoService |
| textserviceutils | TextService utilities | TextServiceUtils |
| contentproviderutils | ContentProvider utilities | ContentProviderUtils, ImageLabelLoaded |
| nocollisionconstraintutils | NoCollisionConstraint utilities | NoCollisionConstraintUtils |
| racketingropeconstraint | Racketing rope constraint | RacketingRopeConstraint |
| fzy | Fuzzy matching | Fzy |
| ellipticcurvecryptography | Elliptic curve crypto | EllipticCurveCryptography |
| getpercentexposedutils | Exposure percentage calculation | GetPercentExposedUtils |
| hintscoringutils | Hint scoring | HintScoringUtils |
| transitionmodel | Transition state model | TimedTransitionModel, SpringTransitionModel, TransitionModel |
| conditions | Conditional logic utilities | AdorneeConditionUtils |

## Ragdoll

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| ragdoll | Full ragdoll system with networking | Ragdoll, RagdollService, RagdollServiceClient, Ragdollable, RagdollHumanoidOnDeath, RagdollHumanoidOnFall |
| deathreport | Death reporting | DeathReportService, DeathReportServiceClient, DeathTrackedHumanoid, PlayerDeathTracker, PlayerKillTracker |

## Testing

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| nevermore-test-runner | Test runner for Nevermore packages | NevermoreTestRunnerUtils |

## State Management

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| rodux-actions | Rodux action utilities | RoduxActions, RoduxActionFactory |
| rodux-undo | Rodux undo middleware | UndoableReducer |
