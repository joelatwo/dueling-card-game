Layer 1 — The Skirmish (Playable Core)

Represent a card as a data structure (power value + ability)
Build a hand of 5 cards for each side
Simultaneous face-down card selection
Reveal both cards at the same time
Compare power values, award skirmish point to winner
Display running skirmish score for both sides
Draw 1 card for each side after each skirmish
Detect win condition (first to 3 points ends the duel)
Card data structure (power value, ability reference, name)
Deck data structure (ordered list of cards)
Hand data structure (subset drawn from deck)
Duel state (whose turn, skirmish scores, active cards)
Draw logic (move top card from deck to hand)
Skirmish resolution logic (compare power, return winner)
Win condition check (has either side reached 3 points)
Display both hands as a list of cards (name + power)
Player can select a card from their hand to play
"Confirm" triggers the reveal step
Show both played cards after reveal
Show updated skirmish score after each round
Show a "Duel Over" message when win condition is met
NPC hand is populated from the same draw logic
NPC selects a card (randomly) when player confirms
NPC card participates in the same reveal + resolution flow

🟧 Layer 2 — A Real Duel

Basic NPC "AI" (random card selection for MVP)
Starter deck of ~10 cards (hardcoded for now)
Duel start/end flow (intro → skirmishes → result screen)
Tie-breaking rule (no point awarded is simplest)


🟨 Layer 3 — Card Abilities

Ability hook system (before/after skirmish resolution)
Buff/debuff abilities (modify power of a card in play)
Future manipulation abilities (set a delayed trap/effect)
Past manipulation abilities (alter a resolved skirmish)
Inversion abilities (low power wins instead of high)


🟩 Layer 4 — Progression Loop

Card pack data structure (pool of cards, draw N at random)
Award a card pack on duel win
In-run card collection (cards available this run)
Deck editor screen (add/remove cards between duels)
Deck size validation (enforce min/max limit)


🟦 Layer 5 — World Structure

Region data structure (3 trainers + 1 gym leader)
Trainer node map within a region (free-roam)
Lock gym leader until all 3 trainers defeated
World map showing 4 regions
Region completion tracking
Unlock final boss after all 4 regions cleared


⬛ Layer 6 — NPC & Difficulty

Regional card pools (trainers draw from themed pool)
Gym leader fixed/constrained deck
Difficulty ramp across trainers within a region
Final boss deck + win/loss condition → run complete


⬜ Layer 7 — Run Management

Run start (assign starter deck, clear prior state)
Run loss flow (duel lost → run over, prompt new run)
Run win flow (final boss defeated → victory screen)