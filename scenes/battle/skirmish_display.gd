extends Control
class_name SkirmishDisplay

@onready var NPCList := $NPCList
@onready var PCList := $PCList

const NPC_CARD_PLACEHOLDER_SCENE: PackedScene = preload("res://scenes/npc_card_placeholder.tscn")
const PC_CARD_PLACEHOLDER_SCENE: PackedScene = preload("res://scenes/pc_card_placeholder.tscn")

var skirmishes: Array[Skirmish] = []

func update_display(new_items: Array) -> void:
	skirmishes = new_items
	refresh()

func refresh() -> void:
	# Clear old children
	for child in NPCList.get_children():
		child.queue_free()

	# Add new UI elements
	for skirmish in skirmishes:
		if (skirmish.opponentCard != null):
			var npc_card := skirmish.opponentCard
			print("Adding NPC card: ", npc_card.name)
			NPCList.add_child(npc_card)
		else:
			print("Adding NPC placeholder")
			var placeholder := NPC_CARD_PLACEHOLDER_SCENE.instantiate()
			NPCList.add_child(placeholder)
		if (skirmish.playerCard != null):
			var player_card := skirmish.playerCard
			PCList.add_child(player_card)
		else:
			var placeholder := PC_CARD_PLACEHOLDER_SCENE.instantiate()
			PCList.add_child(placeholder)
