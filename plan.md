# Game Design Document
### [Working Title: Untitled Time TCG]
**Genre:** Roguelike Trading Card Game | **Status:** MVP Design Phase | **Version:** 0.1

---

## Table of Contents
1. [Overview](#1-overview)
2. [Core Game Loop](#2-core-game-loop)
3. [Duel System](#3-duel-system)
4. [Card Design](#4-card-design)
5. [Deck Building](#5-deck-building)
6. [World & Regions](#6-world--regions)
7. [NPC & Trainer Design](#7-npc--trainer-design)
8. [MVP Scope](#8-mvp-scope)

---

## 1. Overview

The player takes the role of a villain assembling forbidden powers of time manipulation, conquering four thematic regions and defeating a final boss to complete a run.

Core inspiration draws from two sources: **Duel for Cardia's** skirmish-based card combat — where future plays can retroactively affect past skirmishes — and the **Pokémon TCG Game Boy game's** overworld structure of gyms, trainers, and map traversal.

> 🎯 **Core Pillars:** Play as the villain. Manipulate time. Conquer the regions. Roguelike runs with meaningful card decisions.

| Attribute | Value |
|---|---|
| Genre | Roguelike Trading Card Game |
| Platform | TBD |
| Target Audience | Fans of Slay the Spire, Pokémon TCG GB, deckbuilders |
| Run Length | ~16 duels + final boss per run |
| Status | MVP Design Phase |

---

## 2. Core Game Loop

### 2.1 Run Structure

| Stage | Description |
|---|---|
| World Map | Node-based map (Slay the Spire style). Player selects a region to enter. |
| Region Entry | Choose entry node on a regional sub-map, then free-roam within the region. |
| Trainers | 3 trainers per region must be defeated before the gym leader is accessible. |
| Gym Leader | A harder duel with a fixed or pool-based deck. Defeating them unlocks the next region. |
| Final Boss | Unlocked after all 4 regions are conquered. Defeating the boss completes the run. |

### 2.2 Between Duels

- Defeating any trainer rewards a pack of cards.
- The player may edit their deck freely between duels, subject to the deck size limit.
- No other inter-duel mechanics in MVP (shops, events, etc. are stretch goals).

### 2.3 Win & Loss

- **Win:** Defeat all 4 gym leaders and the final boss.
- **Loss:** Lose a duel — the run ends. Player starts a new run from scratch.
- Unlockables (new cards, cosmetics) are a post-MVP stretch goal.

---

## 3. Duel System

### 3.1 Skirmish Flow

| Step | Description |
|---|---|
| 1. Play Phase | Both the player and NPC simultaneously play one card face-down from hand. |
| 2. Reveal | Both cards are revealed at the same time. |
| 3. Resolve Abilities | Card special abilities are resolved in the appropriate order (TBD). |
| 4. Score | The card with the higher effective power wins the skirmish point. |
| 5. Check Win | If either side has reached the point threshold (default: 3), the duel ends. |
| 6. Draw | Both players draw 1 card from their deck to refill their hand. |

### 3.2 Hand & Draw Rules

- Both players start each duel with a hand of **5 cards**.
- Both hands are **fully visible** to the player — open information on both sides.
- **1 card** is drawn at the end of each skirmish (after resolution).
- If a player's deck runs out, draw behavior is TBD.

### 3.3 Winning a Duel

- Default win condition: first to **3 skirmish points** wins the duel.
- Card abilities may alter the point threshold — e.g. raising or lowering the required points.

> ⚠️ **Design Note:** Ties in power value need a resolution rule. Options: tie = no point awarded, tie = both get a point, or tie = re-play. TBD during playtesting.

---

## 4. Card Design

### 4.1 Card Anatomy

| Component | Description |
|---|---|
| Power | Numerical value used to determine skirmish winner. Default range: 1–10, but cards may go outside this range for special effect. |
| Special Ability | Text describing the card's effect. May manipulate past skirmishes, future skirmishes, power values, or other game state. |
| Artwork | Thematic illustration. Style TBD. |

### 4.2 Power Values

- Default range is **1–10**, but this is not a hard cap.
- Cards with values of 0, 11, or higher are possible and reserved for rare/special designs.
- The open range is an intentional design affordance for future card sets.

### 4.3 Special Abilities

Abilities are organized by the four regional archetypes (see Section 6). The following categories are in scope for MVP:

| Category | Description |
|---|---|
| Past Manipulation | Retroactively alter the outcome or state of a previously resolved skirmish. |
| Future Manipulation | Set up effects or traps that trigger in a future skirmish. |
| Buff / Debuff | Directly modify the power value of a card (played or in hand). |
| Inversion | Abilities that reward low power values or reverse normal scoring logic. |

> 📌 **Scope Note:** Ability design guardrails and detailed card specs will be developed in a separate card design document during prototype phase.

---

## 5. Deck Building

### 5.1 Deck Rules

| Rule | Detail |
|---|---|
| Deck Size | Strict fixed limit. Target size: 10–15 cards (to be finalized during playtesting). |
| Duplicates | Allowed, but a card must be opened from a pack before it can be added. |
| Starting Deck | Player begins each run with a predefined starter deck (TBD). |
| Editing | Player may freely edit their deck between duels during a run. |

### 5.2 Card Acquisition

- Defeating any trainer or gym leader awards one **card pack**.
- Pack contents are drawn from a pool relevant to the current region (thematic weighting TBD).
- Opened cards are available for the remainder of the current run only (no cross-run persistence in MVP).

> 🔮 **Stretch Goal:** Post-MVP, players may permanently unlock cards across runs, allowing pre-run deck construction from an owned collection.

---

## 6. World & Regions

### 6.1 World Map

- Top-level view: a stylized world map showing the 4 regions.
- Navigation is **node-based** (Slay the Spire style) when entering a region.
- Within a region, the player can **free-roam** between trainer locations.
- Regions may be tackled in any order, though difficulty should scale.

### 6.2 Region Structure

| Element | Detail |
|---|---|
| Trainers | 3 per region. Must all be defeated to unlock the gym leader. |
| Gym Leader | 1 per region. Harder duel, boss-tier deck. |
| NPC Decks | Trainers draw from a regional card pool — consistent theme but slight variance run to run. |
| Gym Leader Deck | Fixed or tightly constrained pool — designed to exemplify the region's mechanic. |

### 6.3 The Four Regions

#### Region 1 — The Echoing Past
**Mechanical Focus:** Retroactive manipulation. Cards played here can alter the outcome of skirmishes that have already been resolved.
- NPC decks emphasize rewinding, overwriting, and revising history.
- Teaches players the foundational time-manipulation mechanic.

#### Region 2 — The Unwritten Future
**Mechanical Focus:** Proactive manipulation. Cards set up effects that trigger in a future skirmish.
- NPC decks emphasize traps, delayed effects, and prediction.
- Rewards forward-thinking play and hand reading.

#### Region 3 — The Fracture Zone
**Mechanical Focus:** Buff / Debuff. Cards directly modify power values of cards in play or in hand.
- NPC decks emphasize power inflation and deflation.
- Introduces a more direct, numbers-focused strategic layer.

#### Region 4 — The Inverted Age
**Mechanical Focus:** Inversion. Low power values become advantageous. Normal scoring and incentives are reversed.
- NPC decks are built around low-value cards with powerful inversion abilities.
- Forces the player to reconsider their deck composition entirely.

> 🎨 **Flavor Note:** Each region's visual identity, name, and lore are TBD. The time-travel / mystical theme should be woven into all four regions with distinct aesthetics.

---

## 7. NPC & Trainer Design

### 7.1 Trainer Types

| Type | Description |
|---|---|
| Standard Trainer | 3 per region. Decks drawn from a regional pool with some variance. Moderate difficulty. |
| Gym Leader | 1 per region. Harder duel. Deck exemplifies the region's mechanic. |
| Final Boss | 1 per run. Unlocked after all 4 regions. Theme and identity TBD. Should feel like a culmination of all mechanics. |

### 7.2 Difficulty Tuning

- Trainer difficulty should ramp within each region and across regions.
- Gym leaders are noticeably harder than standard trainers.
- Specific difficulty parameters (AI behavior, deck power level) to be determined during playtesting.

---

## 8. MVP Scope

### 8.1 In Scope

- Core skirmish loop (simultaneous card play, reveal, score, draw)
- 4 regions × 3 trainers + 1 gym leader each
- Final boss duel
- Fixed deck size (10–15 cards)
- Card pack rewards after each duel
- In-run deck editing between duels
- Open hand information (both sides visible)
- Node-based world map + free-roam within regions
- 4 ability archetypes (past, future, buff/debuff, inversion)

### 8.2 Out of Scope (Stretch Goals)

- Cross-run card unlocks and pre-run deck construction
- In-run events, shops, or rest sites
- Story or narrative content
- Multiplayer
- Cosmetics and unlockables
- Sound design and music (placeholder only for MVP)

### 8.3 TBD / Needs Playtesting

- Exact deck size (10 vs 15)
- Tie-breaking rule for equal power skirmishes
- Draw behavior when deck is exhausted
- Region order and difficulty scaling
- Final boss identity and mechanics
- AI behavior and decision logic for NPCs
- Card ability resolution order

> 📋 **Next Steps:** Build a paper prototype with a minimal card set (1 region, 3 trainers). Validate the core skirmish loop and open-hand feel before digital implementation.
