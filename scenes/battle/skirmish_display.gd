extends Control
class_name SkirmishDisplay

@onready var NPCList := $NPCList
@onready var PCList := $PCList
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
		if(skirmish.opponentCard != null):
			var npc_card := skirmish.opponentCard
			NPCList.add_child(npc_card)
		else:
			var placeholder := Label.new()
			placeholder.text = "No NPC Card"
			NPCList.add_child(placeholder)
		if(skirmish.playerCard != null):
			var player_card := skirmish.playerCard
			PCList.add_child(player_card)
		else:
			var placeholder := Label.new()
			placeholder.text = "No Player Card"
			PCList.add_child(placeholder)
