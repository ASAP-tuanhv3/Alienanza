# OOB ODYSSEY — Game Design Document

> *A Mario Odyssey-Inspired 3D Platformer for Roblox*
> Built with Kenney Platformer Kit · 153 Assets · 14 Categories · 2 Biomes
> Version 1.0 — March 2026

---

## Table of Contents

1. [Game Overview](#1-game-overview)
2. [Core Loop](#2-core-loop)
3. [Mechanics](#3-mechanics)
4. [Game Systems](#4-game-systems)
5. [Game Feel & Juice](#5-game-feel--juice)
6. [Setting & Vibe](#6-setting--vibe)
7. [Level Design & Asset Mapping](#7-level-design--asset-mapping)
8. [Complete Asset Usage Map](#8-complete-asset-usage-map)
9. [Scope & Risk Assessment](#9-scope--risk-assessment)

---

## 1. Game Overview

### Identity

| Field | Details |
|---|---|
| **Title (Working)** | Oob Odyssey |
| **Logline** | Run, jump, and hat-throw your way across whimsical grass and snow kingdoms to rescue your stolen friends. |
| **Genre** | 3D Platformer / Collectathon |
| **Player Count** | 1 (Solo) with optional co-op lobby (up to 4) |
| **Session Length** | 15–45 minutes per world; 2–3 hours full campaign |
| **Target Audience** | Roblox players ages 8–16 who love exploration and movement mastery |

### Reference Games

| Game | What to Borrow |
|---|---|
| **Super Mario Odyssey** | Hat-throw mechanic, kingdom-based exploration, Power Moon collection loop |
| **Obby Creator (Roblox)** | Obstacle course flow, checkpoint system, Roblox-native feel |
| **Adopt Me / Piggy** | Character appeal, accessible art style, social hooks |

### Core Promise

This game makes players feel **like a platforming hero** — nailing tight jumps, discovering hidden paths, and collecting everything in sight while exploring handcrafted worlds that feel alive.

### 3 Unique Selling Points

1. **Hat-Throw Traversal** — Use your hat as a mid-air platform, a projectile to break crates, and a boomerang to collect distant coins.
2. **Kingdom Duality** — Each world has a Grass side and a Snow side connected by magical portals. Completing challenges on one side unlocks paths on the other.
3. **Character Rescue Chain** — Each rescued Oob friend grants a new passive ability (double jump height, magnet coins, wall slide), making the player progressively more powerful.

---

## 2. Core Loop

### The Heartbeat

1. Player spawns in the **Hub Garden** → sees the World Gate with a star counter showing how many stars are needed to unlock the next kingdom.
2. Player enters a kingdom → explores grass/snow biome, platforming across terrain blocks, avoiding hazards (saws, spike traps, bombs).
3. Player collects coins (bronze=1, silver=5, gold=10) scattered along paths and hidden in crates/barrels.
4. Player completes challenges (reach the flag, survive a gauntlet, find all jewels, defeat a mini-boss) to earn **Power Stars**.
5. Power Stars unlock new areas within the kingdom and new kingdoms via the Hub. Rescued characters add new abilities.
6. After collecting enough stars, the final kingdom unlocks → climactic platforming gauntlet → victory celebration → freeplay mode.

| Condition | Details |
|---|---|
| **Win Condition** | Collect 50 of 75 total Power Stars to unlock and complete the Final Kingdom. |
| **Loss Condition** | No permadeath. Falling off = respawn at last checkpoint. Losing all 3 hearts = respawn at kingdom entrance. Hearts regenerate from heart pickups. |
| **Replay Hook** | Remaining 25 stars offer hard-mode challenges, hidden paths, and speedrun leaderboards per kingdom. Completionists unlock a secret 6th character skin. |

---

## 3. Mechanics

### ▶ Movement

| Attribute | Details |
|---|---|
| **What the player does** | WASD/stick to run, Space/A to jump. Hold jump for higher arc. Crouch + jump for backflip (1.5x height). |
| **Why it feels good** | Tight, responsive controls with slight air control. Landing on slopes gives a satisfying slide. The character has a slight bob and lean into turns. |
| **Values** | Walk speed: 24 studs/s · Run speed: 36 studs/s · Jump height: 12 studs · Backflip: 18 studs · Air control: 60% of ground speed · Coyote time: 0.15s |
| **Interactions** | Hat throw cancels into jump. Wall slide slows fall to 8 studs/s. Springs launch at 60 studs/s vertical. |

### ▶ Hat Throw

| Attribute | Details |
|---|---|
| **What the player does** | Press E/X to throw hat forward. It travels 20 studs, hovers for 0.8s, then returns. Jump on it mid-air for a hat-bounce (extra 8 studs height). |
| **Why it feels good** | Feels like an extension of your body. The boomerang return with coin magnet is incredibly satisfying. Skill ceiling: chain hat-bounce into wall jump into backflip. |
| **Values** | Throw range: 20 studs · Hover time: 0.8s · Cooldown: 0.3s after return · Damage: breaks crates, stuns enemies for 2s · Hat-bounce height: 8 studs |
| **Interactions** | Core synergy with movement. Hat breaks crate-item and crate-strong containers. Hits buttons and levers from range. Cannot be used while wall-sliding. |

### ▶ Coin Collection

| Attribute | Details |
|---|---|
| **What the player does** | Walk through coins to collect. Hat throw magnets nearby coins (5 stud radius). Bronze, Silver, Gold coins scattered everywhere. |
| **Why it feels good** | Constant positive feedback. The "ding-ding-ding" of collecting a coin trail is a dopamine hit. Spending coins at shops for cosmetics feels rewarding. |
| **Values** | Bronze: 1 pt · Silver: 5 pts · Gold: 10 pts · Jewel: 25 pts + star challenge counter · Magnet radius: 5 studs · Shop prices: 50–500 coins |
| **Interactions** | Hat throw enables distant collection. Some coins only reachable via hat-bounce or wall jump. Coin count persists across deaths. |

### ▶ Checkpoint System

| Attribute | Details |
|---|---|
| **What the player does** | Touch a flag to activate a checkpoint. Flags glow and animate when activated. Respawn here on death. |
| **Why it feels good** | Safety net that encourages risk-taking. Seeing a flag ahead motivates "just one more try." Never lose more than 30 seconds of progress. |
| **Values** | Checkpoint spacing: every 30–45 seconds of gameplay · Health restore: full 3 hearts on checkpoint · Visual: flag unfurls with particle burst |
| **Interactions** | Flags placed before every hazard gauntlet and after every major challenge. Star collection auto-saves regardless of checkpoint. |

### ▶ Hazard Interactions

| Attribute | Details |
|---|---|
| **What the player does** | Dodge saws (moving back and forth), jump over spike traps (1.5s on, 1.5s off cycle), avoid bombs (3s fuse, 8 stud blast radius). |
| **Why it feels good** | Rhythm-based dodging feels like a dance. Near-misses with saws create tension. Bombs can be hat-thrown back at breakable walls. |
| **Values** | Saw damage: 1 heart · Spike damage: 1 heart · Bomb damage: 2 hearts · Saw speed: 12 studs/s · Bomb fuse: 3s · Blast radius: 8 studs · i-frames: 1.5s |
| **Interactions** | Bombs interact with crate-strong (only way to break). Saws can cut fence-rope to reveal secret paths. Conveyor belts push player at 10 studs/s. |

### ▶ Character Rescue

| Attribute | Details |
|---|---|
| **What the player does** | Find a locked cage in each kingdom. Collect the key hidden in a challenge area. Free the Oob character to gain a permanent passive ability. |
| **Why it feels good** | Emotional payoff — the rescued character does a happy dance. New ability immediately opens up new traversal options in the current level. |
| **Values** | 5 characters: Oobi (starter), Oodi (+2 jump height), Ooli (wall slide), Oopi (coin magnet x2 radius), Oozi (damage resistance, 4 hearts) |
| **Interactions** | Each ability stacks. Rescuing all 5 unlocks the secret character skin. Lock + key items from the asset kit used directly. |

---

## 4. Game Systems

### Player Stats & Progression

Players start as Oobi with base stats. Each rescued character adds a passive buff that stacks. No level-up grind — progression is ability-gated exploration.

| Stat | Details |
|---|---|
| **Base Health** | 3 hearts (displayed as heart collectible models in HUD) |
| **Coin Wallet** | Persistent across sessions. Spent at cosmetic shops in Hub. |
| **Star Count** | Global counter. 50/75 to reach Final Kingdom. Displayed on Hub gate. |
| **Ability Slots** | Up to 4 passive abilities from rescued characters. All active simultaneously. |

### Enemy / NPC Behavior

Enemies are minimal — this is a platformer, not a combat game. Hazards (saws, spikes, bombs) are the primary threats. Two simple enemy types:

| Enemy | Behavior |
|---|---|
| **Patrol Walker** | Walks back and forth on a platform. Hat throw stuns for 2s, jump-on defeats. Drops 3 bronze coins. |
| **Bomb Thrower** | Stationary. Lobs bombs every 4s in an arc toward player. Hat throw stuns for 3s. Drops 1 silver coin. |

### Map / Environment System

The game world is structured as a Hub + 5 Kingdoms. Each kingdom has two biomes (Grass and Snow) connected by portals. The Kenney asset kit directly maps to these biomes:

| Kingdom | Description |
|---|---|
| **Hub Garden** | Small social space with world gate, cosmetic shop, and leaderboard signs. Uses grass blocks + nature assets. |
| **K1: Meadow Heights** | Tutorial kingdom. Gentle slopes, wide platforms, few hazards. Teaches jump, hat throw, coin collection. |
| **K2: Frostbite Peaks** | Vertical kingdom. Lots of climbing, ladders, narrow ledges. Introduces wall slide after rescuing Ooli. |
| **K3: Overhang Caverns** | Overhang-heavy. Upside-down platforming, hidden paths under overhangs. Introduces bomb interaction. |
| **K4: Moving Madness** | Moving platforms and conveyor belts dominate. Timing-focused. Introduces saw gauntlets. |
| **K5: The Final Kingdom** | Remix of all mechanics. Requires 50 stars to enter. Ultimate gauntlet + celebration ending. |

---

## 5. Game Feel & Juice

### Key Feedback Moments

- **Coin collect:** quick scale-up + gold particle burst + ascending pitch chime (ding, ding, DING for combos)
- **Star collect:** dramatic slow-mo (0.3s), star spins above head, firework particles, triumphant jingle, HUD star counter animates
- **Hat throw hit:** screen shake (2px, 0.1s), impact particles, satisfying THWACK sound. Crates explode into plank particles.
- **Death:** character goes wide-eyed, pops into particles, quick fade to black, respawn with a bounce landing
- **Character rescue:** cage breaks with golden particles, rescued character does unique dance, ability icon flies into HUD slot
- **Checkpoint flag:** unfurls with cloth physics simulation, green particle ring expands outward, gentle chime

### Camera

| Context | Behavior |
|---|---|
| **Default** | Third-person, 15 studs behind, 8 studs above. Smooth follow with 0.2s lerp. |
| **Combat/Hazard** | Pulls back to 20 studs for wider view in gauntlet sections. |
| **Indoors/Tight** | Moves closer (10 studs) and higher angle in cave/overhang sections. |
| **Star Collect** | Orbits around player during celebration. Returns to normal after 2s. |

### Pacing

The game alternates between exploration (slow, curious, rewarding) and challenge (fast, tense, skill-testing) in a 60/40 ratio. Each kingdom starts gentle, ramps to a peak challenge, then offers a cool-down area with collectibles before the next ramp.

### The One Animation That Makes It Alive

**The hat throw and return.** When the hat flies out, spins in the air, hovers with a gentle bob, then snaps back to the player's head with a satisfying *pop* — that single animation loop IS the game. It should feel as good as Mario's Cappy throw. Every other animation supports this one.

---

## 6. Setting & Vibe

| Aspect | Details |
|---|---|
| **World in 3 Words** | Chunky, cheerful, adventurous |
| **Art Direction** | Kenney low-poly style. Warm earth tones (orange/brown) for terrain, vibrant greens and whites for biomes. No realistic textures. |
| **Tone** | Cozy and encouraging. Failure is gentle (cute death animation). Success is loud and celebratory. Zero toxicity. |
| **Audio Direction** | Upbeat orchestral + chiptune hybrid. Each kingdom has a unique theme. Snow areas add sleigh bells and soft pads. |

---

## 7. Level Design & Asset Mapping

### Map Legend

All level maps use the following symbols. Each map represents a top-down schematic of one kingdom section.

| Symbol | Meaning |
|---|---|
| `G` | Grass block (standard) |
| `g` | Grass block (low) |
| `S` | Snow block (standard) |
| `s` | Snow block (low) |
| `L` | Large block |
| `~` | Slope / ramp |
| `^` | Overhang block |
| `C` | Curve block |
| `H` | Hexagon block |
| `=` | Moving platform |
| `>` | Conveyor belt |
| `#` | Fence / barrier |
| `T` | Tree / nature |
| `F` | Flowers / grass decoration |
| `*` | Coin (bronze/silver/gold) |
| `★` | Power Star location |
| `♥` | Heart pickup |
| `K` | Key location |
| `!` | Hazard (saw/spike/bomb) |
| `?` | Crate / barrel / chest |
| `@` | Checkpoint flag |
| `P` | Player spawn |
| `O` | Portal (grass ↔ snow) |
| `D` | Door |
| `↑↓←→` | Directional flow |
| `[ ]` | Elevated platform |
| `...` | Gap / void |

---

### Kingdom 1: Meadow Heights

The tutorial kingdom. Wide platforms, gentle slopes, and generous checkpoints teach core mechanics one at a time. The Grass side is open and sunny; the Snow side introduces slightly tighter platforming.

#### Section A: Welcome Meadow (Grass Side)

*Teaches running, jumping, and coin collection. No hazards.*

```
  P---GGGGGGG---*--*--*---GGGGG---@---GGGGGG
  |   T  F  T   *     *   T   T       F    |
  |   GGGGGGG   *  *  *   GGGGG   GGGGGGGG |
  |        \~~~~~*~~*~~*~~~/       |  ?  ? ||
  |         ggggggggggggggg        | GGGG  ||
  |         F   *  *  *   F        |       ||
  |         ggggg  *  ggggg    ....| [GG]  ||
  |              \ * /         .   |   *   ||
  |               ggg         .   GGGGGGG★||
  |               F           .............||
  +---GGGGG---@---GGGGGGG---*--*---GGGGG---+
      T   T       |     |          T   T
                  |  O  |
                  +-----+
```

#### Section B: Snowcap Intro (Snow Side)

*First snow area. Teaches hat throw on crates. One simple hazard.*

```
  O---SSSSSSS---*--*---SSSSS---@---SSSSSS
  |       s s    *  *      |       |    | |
  |   SSSSSSS    * ?*  SSSSS   SSSSSSSS | |
  |        \~~~~~~*~~~~~/ !     |  ?  ? || |
  |         sssssssssss   !     | SSSS  || |
  |             *  *      !     |       || |
  |         sssss  sssss  ..    | [SS]  || |
  |              \ * /    .     |  ♥   || |
  |               sss    .     SSSSSSS★|| |
  |               #      ..............|| |
  +---SSSSS---@---SSSSSSS---*--*---SSSSS--+
```

**Star Breakdown:** 15 Power Stars total. 8 on Grass side (reach the flag ×3, coin challenge ×2, crate smash ×2, hidden path ×1). 7 on Snow side (reach the flag ×3, hat throw challenge ×2, character rescue ×1, time trial ×1).

---

### Kingdom 2: Frostbite Peaks

A vertical kingdom focused on climbing. Ladders, narrow blocks, and tall structures dominate. Rescuing Ooli here grants wall slide, which opens up new routes.

#### Section A: The Ascent (Grass Side)

*Vertical platforming with ladders and narrow blocks. Introduces wall jumps.*

```
                    [★ GG ★]
                    |  ??  |
                GGGG+------+GGGG
                |              |
           *  [GG]    !    [GG]  *
           *   |      !      |   *
       GGGG+---+  @  !!!  @  +---+GGGG
       |   LADDER    !!!    LADDER   |
       |   |    GGGGG   GGGGG    |  |
   *  [GG] |    T   #   #   T    | [GG]  *
   *   |   |    GGGG  *  GGGG    |  |    *
GGGG+---+---+       \ * /         +--+---+GGGG
|        F     gggggg*gggggg     F        |
|   T    F     *  *  *  *  *     F    T   |
P---GGGGGGGGGGGGGGGGG@GGGGGGGGGGGGGGGGG---+
                    O
```

#### Section B: Ice Spire (Snow Side)

*Tall ice tower. Moving platforms and narrow snow ledges. Key to rescue Ooli at the top.*

```
                    [ K cage]
                    | Ooli! |
                SSSS+-------+SSSS
                |    =    =     |
           *  [SS]  =    =  [SS]  *
           *   |    =    =    |    *
       SSSS+---+ @  ======  @ +---+SSSS
       |   LADDER   !    !  LADDER    |
       |   |   SSSSS  ♥  SSSSS    |   |
   *  [SS] |   # * #    # * #     | [SS]  *
   *   |   |   SSSS  *   SSSS     |  |    *
SSSS+---+---+      \ * /           +--+---+SSSS
|        F    ssssss*ssssss        F       |
|        F    *  *  *  *  *        F       |
O---SSSSSSSSSSSSSSSSS@SSSSSSSSSSSSSSSSSSS--+
```

**Star Breakdown:** 15 Power Stars. Climbing challenges ×4, ladder races ×2, hidden wall-jump alcoves ×3, Ooli rescue ×1, coin trails ×3, time trial ×1, boss platform ×1.

---

### Kingdom 3: Overhang Caverns

A kingdom built around the overhang blocks. Paths weave above and below terrain. Hidden routes under overhangs reward exploration. Bomb interaction is introduced here — bombs break strong crates blocking secret areas.

#### Section A: Canopy Crossing (Grass Side)

*Multi-layered terrain with overhangs hiding secrets below.*

```
  P---GGGGGGG---*---^^^^^^^^^^^---@---GGGGG★
  |   T  F  T   *   ^ HIDDEN  ^       T  ||
  |   ^^^G^^^   *   ^ ?  ♥  ? ^   GGGGG ||
  |   ^ * * ^   *   ^^^^^^^^^^^   |   | ||
  |   ^?   ?^   *       * *       | ! | ||
  |   ^^^^^^^---*---GGGGGGGGG---@-+---+-++
  |         |           |    |
  |    GGGGG+---GGGGG  | ★  |  GGGGGGG
  |    T   #    T   T  |    |  T  F  T
  |    GGGGGGGGGGGGG   +--D-+  GGGGGGG
  |        *  *  *     *  *  *  *  *
  +---@---GGGGGGGGGGGGGGGGGGGGGGGGGGG---+
                       O
```

#### Section B: Frost Underbelly (Snow Side)

*Bomb-throwing enemies guard paths. Strong crates block the way to stars.*

```
  O---SSSSSSS---*---^^^^^^^^^^^---@---SSSSS★
  |       s s   *   ^ BOMBS!  ^       s  ||
  |   ^^^S^^^   *   ^  ?!  ?! ^   SSSSS ||
  |   ^ * * ^   *   ^^^^^^^^^^^   |   | ||
  |   ^?STRONG^  *      * *       | ! | ||
  |   ^^^^^^^---*---SSSSSSSSS---@-+---+-++
  |         |           |    |
  |    SSSSS+---SSSSS  | ★  |  SSSSSSS
  |    #    #       #  |    |  #  F  #
  |    SSSSSSSSSSSSS   +--D-+  SSSSSSS
  |        *  *  *     *  *  *  *  *
  +---@---SSSSSSSSSSSSSSSSSSSSSSSSSSSSS---+
```

**Star Breakdown:** 15 Power Stars. Hidden under-overhang stars ×4, bomb puzzle stars ×3, strong crate destruction ×3, exploration stars ×2, character rescue ×1, time trial ×1, coin challenge ×1.

---

### Kingdom 4: Moving Madness

The toughest kingdom before the finale. Moving platforms, conveyor belts, and saw gauntlets test timing and precision. Every surface is in motion.

#### Section A: Conveyor Canyon (Grass Side)

*Conveyor belts and moving platforms demand precise timing.*

```
  P--->>>>>>---=  =  =---@---GGGGG★
  |   >>>>>> * =  =  = *     T  ||
  |   GGGGGG   =  =  =   GGGGG ||
  |     !  !   ========   | ♥ | ||
  |   >>>>>>   =      =   +---+ ||
  |   >>>>>> * =  !   = *       ||
  |   GGGGGG   =  !   =   @-GGGG+
  |        \   ========       |
  |    GGG  \  =      =  GGGGG
  |    * *   GGG  =  =  GG * *
  |    * *       =  =     * *
  +---@---GGGGGGG====GGGGGGG---+
                  O
```

#### Section B: Saw Summit (Snow Side)

*Saw gauntlets on narrow snow platforms. The ultimate skill test before the finale.*

```
  O---SSSS---!---!---!---@---SSSSS★
  |    s s  !   !   !   !     s ||
  |   =SSS=  !   !   !    SSSSS ||
  |   = ! =  =========    | K  | ||
  |   =====  =       =    +cage+ ||
  |    ! !   =  !!!  =  *       ||
  |   SSSSS  =  !!!  =  @-SSSSS+
  |       \  =========       |
  |   SSS  \  =      = SSSSS
  |   * *   SSS  =  = SS * *
  |   * *       =  =    * *
  +---@---SSSSSSS====SSSSSSS---+
```

**Star Breakdown:** 15 Power Stars. Moving platform gauntlets ×4, conveyor puzzles ×3, saw dodge challenges ×3, speed runs ×2, character rescue ×1, hidden alcoves ×2.

---

## 8. Complete Asset Usage Map

### Terrain Blocks

| Asset | Usage | Level(s) |
|---|---|---|
| block-grass / block-snow | Primary floor tiles, standard height | All kingdoms |
| block-\*-large | Wide platforms, open areas | K1 Welcome Meadow, Hub |
| block-\*-large-tall | Elevated platforms, tower bases | K2 Ascent, K5 Finale |
| block-\*-narrow | Tight ledges, precision sections | K2, K4 Saw Summit |
| block-\*-long | Bridges, extended walkways | K1, K3 Canopy Crossing |
| block-\*-low / low-large | Ground-level detail, shallow steps | All kingdoms (decoration) |
| block-\*-hexagon | Unique platform shapes, puzzle areas | K3 Caverns, K5 Finale |
| block-\*-corner / edge | Terrain borders, path turns | All kingdoms |
| block-\*-curve / curve-half | Rounded paths, aesthetic curves | K1, Hub Garden |
| block-\*-large-slope\* | Ramps, elevation changes | K1, K2, K3 |
| block-\*-overhang-\* | Hidden paths underneath | K3 (primary), K5 |

### Characters & Collectibles

| Asset | Usage | Level(s) |
|---|---|---|
| character-oobi | Starter character (player) | All — default skin |
| character-oodi | Rescue in K1 → +2 jump height | K1 Snow Side |
| character-ooli | Rescue in K2 → wall slide | K2 Ice Spire |
| character-oopi | Rescue in K3 → 2x coin magnet | K3 Frost Underbelly |
| character-oozi | Rescue in K4 → 4th heart | K4 Saw Summit |
| coin-bronze / silver / gold | Currency: 1 / 5 / 10 value | All kingdoms |
| heart | Restores 1 health heart | All kingdoms, near hazards |
| jewel | 25 coins + star challenge counter | Hidden locations all kingdoms |
| key | Unlocks character cages | One per kingdom (K1–K4) |
| star | Power Star — main progression | 75 total across all kingdoms |

### Interactive & Structural

| Asset | Usage | Level(s) |
|---|---|---|
| button-round / square | Trigger doors, platforms, bridges | K2, K3, K4 |
| lever | Toggle hazards on/off, open paths | K3, K4, K5 |
| sign | Tutorial text, hints, lore | All kingdoms |
| door-open / door-rotate | Passage between areas | K3 Caverns, K5 Finale |
| door-large-open / rotate-large | Kingdom boss arena entrances | K2, K4, K5 |
| lock | Visual indicator on cages/doors | K1–K4 rescue areas |
| flag | Checkpoint marker | Every 30–45s of gameplay |
| ladder / ladder-long | Vertical traversal | K2 (primary), K3, K5 |
| ladder-broken | Decoration / environmental storytelling | K3, K4 |
| spring | Launch pad, 60 studs/s vertical boost | K1, K2, K4, K5 |
| conveyor-belt | Pushes player at 10 studs/s | K4 (primary) |
| platform / fortified / overhang | Floating platforms, ramp sections | All kingdoms |

### Hazards & Containers

| Asset | Usage | Level(s) |
|---|---|---|
| saw | Moving hazard, 1 heart damage | K4 (primary), K3, K5 |
| spike-block / wide | Static hazard, timed cycle | K2, K3, K4, K5 |
| trap-spikes / large | Floor trap, 1.5s on/off cycle | K3, K4, K5 |
| bomb | 3s fuse, 8 stud blast, breaks strong crates | K3 (primary), K4, K5 |
| crate / crate-item | Breakable with hat throw, drops coins | All kingdoms |
| crate-strong / crate-item-strong | Only breakable with bombs | K3 (primary), K4, K5 |
| barrel | Breakable container, random drops | K1, K3, K5 |
| chest | Contains star or major collectible | 1–2 per kingdom |
| block-moving / blue / large | Moving platforms on rails | K4 (primary), K2, K5 |

### Nature & Props

| Asset | Usage | Level(s) |
|---|---|---|
| tree / tree-pine / tree-pine-small | Grass biome decoration | K1, K3, Hub |
| tree-snow / tree-pine-snow\* | Snow biome decoration | K2, K4, K5 |
| flowers / flowers-tall | Ground decoration, path markers | K1, Hub, K3 |
| grass / plant / mushrooms | Ambient detail | All grass areas |
| hedge / hedge-corner | Path borders, maze elements | Hub Garden, K1 |
| rocks / stones | Environmental detail, obstacles | All kingdoms |
| fence-\* (all 9 variants) | Barriers, path edges, safety rails | All kingdoms |
| arrow / arrows | Directional hints for players | Tutorial areas, K1 |
| brick | Structural detail, wall elements | K3 Caverns, K5 |
| pipe | Decorative, possible warp pipe mechanic | K3, K5 |
| poles | Flagpole bases, structural | Checkpoint locations |

---

## 9. Scope & Risk Assessment

### Scope Flags

- ⚠️ **Hat-throw physics** — Getting the boomerang return + hat-bounce to feel right will require extensive tuning. Budget 2–3 days just for this.
- ⚠️ **5 full kingdoms** — Consider launching with 3 kingdoms (K1, K2, K3) and adding K4/K5 post-launch. Each kingdom is ~40 hours of level design.
- ⚠️ **Co-op mode** — Defer to post-launch. Solo experience must be solid first. Network sync for platformers is notoriously tricky.
- ⚠️ **Camera in tight spaces** — Overhang sections (K3) will need custom camera zones to avoid clipping. Test early.
- ⚠️ **Moving platform sync** — Roblox physics can desync moving platforms. Use CFrame tweening, not physics simulation.

### MVP Milestone

The Minimum Viable Product should include: Hub Garden + Kingdom 1 (both biomes) + 15 collectible stars + hat throw mechanic + checkpoint system + 1 character rescue. This validates the core loop before building remaining kingdoms.

### Development Priority Order

1. Character controller (movement + jump + camera) — this must feel perfect
2. Hat throw mechanic (throw, hover, return, hat-bounce, crate break)
3. Coin collection + HUD (counter, particles, sound)
4. Checkpoint system (flag activation, respawn logic)
5. Kingdom 1 level layout using Kenney terrain blocks
6. Star collection + Hub gate unlock logic
7. Hazard system (saws, spikes, bombs with interactions)
8. Character rescue system (key + lock + ability grant)
9. Kingdoms 2–5 level design and population
10. Polish pass (particles, sounds, camera zones, UI)