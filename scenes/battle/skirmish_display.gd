extends VBoxContainer
class_name SkirmishDisplay

var skirmishes: Array[Skirmish] = []

func _ready() -> void:
	pass

func update_display(skirmishes_to_display: Array[Skirmish]) -> void:
	skirmishes = skirmishes_to_display
	
	# Clear existing display immediately
	while get_child_count() > 0:
		remove_child(get_child(0))
	
	# Create vertical container for NPC and Player rows
	var main_container = VBoxContainer.new()
	main_container.layout_mode = 1  # LAYOUT_MODE_FILL
	main_container.alignment = BoxContainer.ALIGNMENT_BEGIN
	
	# NPC cards row (top)
	var npc_row = HBoxContainer.new()
	npc_row.layout_mode = 1  # LAYOUT_MODE_FILL
	npc_row.alignment = BoxContainer.ALIGNMENT_BEGIN
	for skirmish in skirmishes:
		if skirmish.opponentCard:
			npc_row.add_child(skirmish.opponentCard)
	main_container.add_child(npc_row)
	
	# Player cards row (bottom)
	var player_row = HBoxContainer.new()
	player_row.layout_mode = 1  # LAYOUT_MODE_FILL
	player_row.alignment = BoxContainer.ALIGNMENT_BEGIN
	for skirmish in skirmishes:
		if skirmish.playerCard:
			player_row.add_child(skirmish.playerCard)
	main_container.add_child(player_row)
	
	add_child(main_container)
	print("Updated skirmish display with %d skirmishes" % skirmishes.size())
