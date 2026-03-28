
The Core Idea in Dev Terms
You need three things working together before anything else matters:

A round resolution system — compare numbers, assign point to winner, trigger loser's power
A card data model — number + power definition + power parameters
A roguelike shell — map/run structure, card rewards between combats

GDScript is close enough to C# that you'll pick it up fast. The main Godot concepts to internalize early are nodes, scenes, and signals — everything else flows from those.

Session Roadmap
Phase 1 — Engine Foundations (Sessions 1–3)
Goal: Get comfortable in Godot before touching game logic
Session 1 — Hello Godot

Install Godot 4, create a project, understand the scene/node tree
Create a Control node UI scene with a button and a label
Wire a button press to update a label via GDScript
Exit criteria: you made something happen on screen with code you wrote

Session 2 — Your First Scene Architecture

Create a Card scene with a label for number and a label for power name
Create a Hand scene that holds 3–5 card instances
Pass data into cards from a parent node (no hardcoding in the card scene)
Exit criteria: a hand of cards displays with different numbers

Session 3 — Signals and Scene Switching

Wire a card button press to emit a signal up to the Hand
Hand receives it and prints which card was played
Add a second scene (a simple "You win!" screen) and navigate to it
Exit criteria: clicking a card does something meaningful; scenes transition


Phase 2 — Core Combat Loop (Sessions 4–7)
Goal: One full round of combat works end-to-end
Session 4 — Card Data Model

Define a CardResource (Godot Resource) with: card_name, power_number, power_id, power_params
Create 6–8 cards as .tres resource files (no powers yet, just numbers)
Load them in code and display in the Hand scene
Exit criteria: cards come from data, not hardcoded scenes

Session 5 — NPC Hand and Round Resolution

Create a simple NPC node that holds its own hand of cards
Build a CombatManager that receives a played card, picks an NPC card, compares numbers
Display who won the round and update a score counter
Exit criteria: you can play a card and see a result

Session 6 — The Loser Power Hook

Add a PowerResolver node that takes a power_id and executes logic
Implement 2 powers: one that does nothing (baseline) and one simple one (e.g. +1 to a score)
CombatManager calls PowerResolver on the losing card after each round
Exit criteria: losing a round triggers a visible effect

Session 7 — Full Combat Round

Play through a full hand (5 rounds), tally points, show win/loss screen
Add the "retroactive" power type — one power that modifies a past round's score
Store round history so retroactive powers have something to act on
Exit criteria: one complete combat plays out with at least one interesting power


Phase 3 — Roguelike Shell (Sessions 8–12)
Goal: Multiple combats in a run with card rewards
Session 8 — Run State

Create a RunManager autoload (singleton) that persists across scenes
It holds: current deck, current health/score, run progress
Exit criteria: data survives a scene transition

Session 9 — Map Screen

Simple linear map: 3 combat nodes → 1 reward node → repeat
Clicking a node loads the combat scene with that encounter's data
Exit criteria: you can navigate a basic map

Session 10 — Card Rewards

After combat, show 3 random cards to choose from
Selected card added to RunManager deck
Exit criteria: your deck grows across a run

Session 11 — Enemy Variety

Define 2–3 enemy types with different decks and simple AI (random, or prefer low cards, etc.)
Wire enemy type to map nodes
Exit criteria: combats feel different depending on who you fight

Session 12 — Run Loop Closes

Add a final boss encounter
Show a run summary screen (rounds won, cards played, powers triggered)
Allow starting a new run
Exit criteria: you can play a complete run start to finish


Phase 4 — Content & Feel (Sessions 13+)
Expand once the loop is solid

More powers (especially more retroactive/timeline-bending ones — that's your design hook)
Deck-building tension: when to add cards vs. keep deck tight
Visual polish: animations on round resolution, power activation feedback
Balance passes: playtesting and tuning numbers
Optional: simple meta-progression between runs

