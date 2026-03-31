Phase 1 — Detailed Session Plans

Minutes 5–20 — The Card scene

Create a new scene: Scene → New Scene
Add a root node of type PanelContainer (it gives you a visible box automatically). Rename it Card.
Add two children:

VBoxContainer (stacks children vertically) — child of PanelContainer
Inside the VBox: a Label named NumberLabel and a Label named PowerLabel

Attach a script to the Card root, save as card.gd
Write this in the script:

gdscriptextends PanelContainer

func setup(number: int, power_name: String):
$VBoxContainer/NumberLabel.text = str(number)
$VBoxContainer/PowerLabel.text = power_name

Save the scene as card.tscn

Minutes 20–40 — The Hand scene

Create another new scene. Root node: HBoxContainer (arranges children side by side). Rename it Hand.
Attach a script, save as hand.gd
Write this:

gdscriptextends HBoxContainer

const CardScene = preload("res://card.tscn")

func \_ready():
var cards = [
{number = 7, power_name = "Riposte"},
{number = 3, power_name = "Echo"},
{number = 5, power_name = "Nullify"},
]
for card_data in cards:
var card = CardScene.instantiate()
add_child(card)
card.setup(card_data.number, card_data.power_name)

Save as hand.tscn
Set hand.tscn as the main scene (Project → Project Settings → Application → Run → Main Scene)
Hit F5. You should see three cards side by side.

Minutes 40–60 — Understand and experiment

Key concepts to internalize:

preload vs load — preload happens at compile time, load at runtime
instantiate() — creates a live copy of a scene
add_child() — attaches it to the scene tree so it appears

Experiment: add a 4th card. Change the card dimensions in the Inspector (set a minimum size on the PanelContainer). Try naming a node wrong in the $ path and read the error.
Write your session note.

Session 3 — Signals and Scene Switching
Goal: A card click does something meaningful; the game can navigate between scenes.
Minutes 0–5 — Warmup

Run your project. Three cards display. Good.

Minutes 5–20 — Make cards clickable

Open card.tscn. Add a Button node as a child of the PanelContainer (alongside the VBoxContainer, or wrapping it — your call visually).
In card.gd, add a signal and connect the button:

gdscriptextends PanelContainer

signal card_played(card_node)

func setup(number: int, power_name: String):
$VBoxContainer/NumberLabel.text = str(number)
$VBoxContainer/PowerLabel.text = power_name

func \_on_button_pressed():
emit_signal("card_played", self)

Connect the button's pressed signal to \_on_button_pressed (via the Node tab, same as Session 1)

Minutes 20–35 — Hand listens to cards

Open hand.gd. After add_child(card) and card.setup(...), connect the card's signal:

gdscriptcard.card_played.connect(\_on_card_played)

Add the handler function:

gdscriptfunc \_on_card_played(card_node):
print("Played: ", card_node.get_node("VBoxContainer/NumberLabel").text)
card_node.queue_free() # remove the card from hand

Run it. Click a card. Check the Output panel at the bottom — you should see the number printed. The card should disappear.

Minutes 35–50 — Add a second scene and navigate to it

Create a new scene. Root: Control. Rename it ResultScreen.
Add a Label with text "Combat Over!" and a Button with text "Play Again"
Attach a script result_screen.gd:

gdscriptextends Control

func \_on_button_pressed():
get_tree().change_scene_to_file("res://hand.tscn")

Connect the button's pressed signal to that function.
Save as result_screen.tscn
Back in hand.gd, update \_on_card_played to switch scenes when all cards are gone:

gdscriptfunc \_on_card_played(card_node):
card_node.queue_free()
await get_tree().process_frame # wait one frame so queue_free finishes
if get_child_count() == 0:
get_tree().change_scene_to_file("res://result_screen.tscn")

Run it. Play all three cards. You should land on the result screen. Hit Play Again, you're back.

Minutes 50–60 — Understand and experiment

Key concepts:

Signals decouple nodes — the Card doesn't need to know what the Hand does with the event
queue_free() vs free() — always use queue_free() to avoid mid-frame deletion crashes
change_scene_to_file() — the main way to navigate in Godot

Experiment: pass the played card's number to the result screen and display it. Try emitting a signal with multiple parameters.
Write your session note.

After these three sessions you'll have real Godot instincts — scenes, scripts, signals, and navigation — all learned through your actual project. Session 4 is where the game logic starts. Want me to detail Phase 2 the same way?
