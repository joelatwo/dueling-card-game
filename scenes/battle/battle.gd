extends Node

enum TurnState {
	START_OF_TURN,
	PLAYER_PLAYS_CARD,
	NPC_PLAYS_CARD,
	COMPARE_CARDS,
	AWARD_POINT,
	ACTIVATE_ABILITY,
	RECALCULATE,
	CHECK_END_CONDITION
}

var skirmishes: Array[Skirmish] = []
var state: TurnState = TurnState.START_OF_TURN
var player_score: int = 0
var npc_score: int = 0
var current_skirmish: Skirmish
var player_hand: Hand
var npc_hand: Hand
var play_cards_button: Button
var state_label: Label
var skirmish_display: VBoxContainer
var player_card_selected: bool = false
const WIN_SCORE = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Initializing Game")
	var root_scene = get_tree().current_scene
	player_hand = root_scene.get_node("Game/Player Hand") as Hand
	npc_hand = root_scene.get_node("Game/NPC Hand") as Hand
	play_cards_button = root_scene.get_node("Game/PlayCardsButton") as Button
	state_label = root_scene.get_node("Game/StateLabel") as Label
	skirmish_display = root_scene.get_node("Game/SkirmishDisplay") as VBoxContainer
	play_cards_button.pressed.connect(_on_play_cards_button_pressed)
	# Populate hands with fake cards
	var card_scene = preload("res://scenes/card/card_ui.tscn")
	for i in 5:
		var card = card_scene.instantiate()
		player_hand.add_child(card)
		var card2 = card_scene.instantiate()
		npc_hand.add_child(card2)
	advance(TurnState.START_OF_TURN)
	print("Game started")

func advance(next_state: TurnState) -> void:
	state = next_state
	_update_state_label()
	_update_skirmish_display()
	_update_button_state()
	_process_state()

func _update_state_label() -> void:
	state_label.text = TurnState.keys()[state]

func _update_skirmish_display() -> void:
	# Clear existing display immediately
	while skirmish_display.get_child_count() > 0:
		skirmish_display.remove_child(skirmish_display.get_child(0))
	
	# Create horizontal container for all skirmishes (left to right)
	var skirmishes_row = HBoxContainer.new()
	skirmishes_row.alignment = BoxContainer.ALIGNMENT_CENTER
	
	# Create a column for each skirmish
	for skirmish in skirmishes:
		var skirmish_column = VBoxContainer.new()
		skirmish_column.alignment = BoxContainer.ALIGNMENT_CENTER
		
		# NPC card placeholder/display (top)
		var npc_container = PanelContainer.new()
		npc_container.custom_minimum_size = Vector2(80, 100)
		var npc_label = Label.new()
		if skirmish.opponentCard:
			npc_label.text = "NPC\n%d" % skirmish.opponentCard.strength
		else:
			npc_label.text = "NPC\n?"
		npc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		npc_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		npc_container.add_child(npc_label)
		skirmish_column.add_child(npc_container)
		
		# Separator
		var separator = Label.new()
		separator.text = "vs"
		separator.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		skirmish_column.add_child(separator)
		
		# Player card placeholder/display (bottom)
		var player_container = PanelContainer.new()
		player_container.custom_minimum_size = Vector2(80, 100)
		var player_label = Label.new()
		if skirmish.playerCard:
			player_label.text = "Player\n%d" % skirmish.playerCard.strength
		else:
			player_label.text = "Player\n?"
		player_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		player_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		player_container.add_child(player_label)
		skirmish_column.add_child(player_container)
		
		# Winner
		if skirmish.winner:
			var winner_label = Label.new()
			winner_label.text = "[%s]" % skirmish.winner.to_upper()
			winner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			skirmish_column.add_child(winner_label)
		
		skirmishes_row.add_child(skirmish_column)
	
	skirmish_display.add_child(skirmishes_row)
	print("Updated skirmish display with %d skirmishes" % skirmishes.size())

func _update_button_state() -> void:
	if state == TurnState.PLAYER_PLAYS_CARD:
		play_cards_button.disabled = !player_card_selected
		play_cards_button.visible = true
	else:
		play_cards_button.visible = false

func _on_play_cards_button_pressed() -> void:
	if state == TurnState.PLAYER_PLAYS_CARD:
		if player_hand.get_child_count() > 0:
			var card = player_hand.get_child(0)
			player_hand.remove_child(card)
			current_skirmish.playerCard = card
			print("Player locked in card: ", card.name)
			advance(TurnState.NPC_PLAYS_CARD)
		else:
			print("Player has no cards, NPC wins")
			npc_score = WIN_SCORE
			advance(TurnState.CHECK_END_CONDITION)
	
func _process_state() -> void:
	match state:
		TurnState.START_OF_TURN:
			_start_of_turn()
		
		TurnState.PLAYER_PLAYS_CARD:
			_player_plays_card()
			
		TurnState.NPC_PLAYS_CARD:
			_npc_plays_card()
			
		TurnState.COMPARE_CARDS:
			_compare_cards()
			
		TurnState.AWARD_POINT:
			_award_point()

		TurnState.ACTIVATE_ABILITY:
			_activate_ability()
			
		TurnState.RECALCULATE:
			_recalculate()
			
		TurnState.CHECK_END_CONDITION:
			_check_end_condition()

func _start_of_turn() -> void:
	print("Start of turn")
	current_skirmish = Skirmish.new()
	skirmishes.append(current_skirmish)
	print("Moving to player card selection...")
	advance(TurnState.PLAYER_PLAYS_CARD)

func _player_plays_card() -> void:
	print("Player selecting a card - click the button to lock in the leftmost card")
	player_card_selected = true
	_update_button_state()

func _npc_plays_card() -> void:
	print("NPC plays card")
	if npc_hand.get_child_count() > 0:
		var card = npc_hand.get_child(0)
		npc_hand.remove_child(card)
		current_skirmish.opponentCard = card
		print("Waiting to compare cards...")
		# TODO: Automatically advance to COMPARE_CARDS when ready
		# advance(TurnState.COMPARE_CARDS)
	else:
		print("NPC has no cards, Player wins")
		player_score = WIN_SCORE
		advance(TurnState.CHECK_END_CONDITION)

func _compare_cards() -> void:
	print("Comparing cards")
	var p_strength = current_skirmish.playerCard.strength
	var n_strength = current_skirmish.opponentCard.strength
	print("Player card strength: ", p_strength, " NPC card strength: ", n_strength)
	if p_strength > n_strength:
		current_skirmish.winner = "player"
	elif n_strength > p_strength:
		current_skirmish.winner = "npc"
	else:
		current_skirmish.winner = "tie"
	print("Waiting to award point...")
	# TODO: Automatically advance to AWARD_POINT when ready
	# advance(TurnState.AWARD_POINT)

func _award_point() -> void:
	print("Awarding point")
	if current_skirmish.winner == "player":
		player_score += 1
		print("Player score: ", player_score)
	elif current_skirmish.winner == "npc":
		npc_score += 1
		print("NPC score: ", npc_score)
	else:
		print("Tie, no point awarded")
	print("Waiting to activate ability...")
	# TODO: Automatically advance to ACTIVATE_ABILITY when ready
	# advance(TurnState.ACTIVATE_ABILITY)

func _activate_ability() -> void:
	print("Activating ability")
	if current_skirmish.winner == "player":
		current_skirmish.opponentCard.activate_ability()
	elif current_skirmish.winner == "npc":
		current_skirmish.playerCard.activate_ability()
	else:
		print("No ability activated due to tie")
	print("Waiting to recalculate...")
	# TODO: Automatically advance to RECALCULATE when ready
	# advance(TurnState.RECALCULATE)

func _recalculate() -> void:
	print("Recalculating")
	print("Player and NPC draw 1 card")
	# For now, no recalculation needed
	print("Waiting to check end condition...")
	# TODO: Automatically advance to CHECK_END_CONDITION when ready
	# advance(TurnState.CHECK_END_CONDITION)

func _check_end_condition() -> void:
	print("Checking end condition")
	if player_score >= WIN_SCORE:
		print("Player wins the game!")
	elif npc_score >= WIN_SCORE:
		print("NPC wins the game!")
	else:
		print("Continuing to next turn")
		advance(TurnState.START_OF_TURN)
