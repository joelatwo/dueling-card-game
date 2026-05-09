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

const AwardedPoint: PackedScene = preload("res://scenes/awarded_point.tscn")

var skirmishes: Array[Skirmish] = []
var state: TurnState = TurnState.START_OF_TURN
var player_score: int = 0
var npc_score: int = 0
var current_skirmish: Skirmish
var player_hand: Hand
var npc_hand: Hand
var skirmish_display: SkirmishDisplay
var play_cards_button: Button
var state_label: Label
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
	skirmish_display = root_scene.get_node("Game/SkirmishDisplay") as SkirmishDisplay
	play_cards_button.pressed.connect(_on_play_cards_button_pressed)
	# Populate hands with fake cards
	var card_scene = preload("res://scenes/card/card_ui.tscn")
	#for i in 5:
		# var card = card_scene.instantiate()
		# player_hand.add_child(card)
		# var card2 = card_scene.instantiate()
		# npc_hand.add_child(card2)
	
	# Initialize 3 test skirmishes
	# for i in range(1, 4):
		# var test_skirmish = Skirmish.new()
		
		# Create player card
		# var player_card = card_scene.instantiate()
		# player_card.name = "player %d" % i
		# player_card.strength = i * 2
		# add_child(player_card)  # Add to scene tree for initialization
		# test_skirmish.playerCard = player_card
		
		# Create NPC card
		# var npc_card = card_scene.instantiate()
		# npc_card.name = "npc %d" % i
		# npc_card.strength = i * 3
		# add_child(npc_card)  # Add to scene tree for initialization
		# test_skirmish.opponentCard = npc_card
		
		# Set winner based on strength
		# if player_card.strength > npc_card.strength:
			# test_skirmish.winner = "player"
		# elif npc_card.strength > player_card.strength:
			# test_skirmish.winner = "npc"
		# else:
			# test_skirmish.winner = "tie"
		
		# skirmishes.append(test_skirmish)
	
	advance(TurnState.START_OF_TURN)
	print("Game started")

func advance(next_state: TurnState) -> void:
	state = next_state
	_update_state_label()
	_process_state()

func _update_state_label() -> void:
	state_label.text = TurnState.keys()[state]

func _update_skirmish_display() -> void:
	skirmish_display.update_display(skirmishes)

func _update_button_state() -> void:
	if state == TurnState.PLAYER_PLAYS_CARD:
		play_cards_button.disabled = !player_card_selected
		play_cards_button.visible = true
	else:
		play_cards_button.visible = false

func _on_play_cards_button_pressed() -> void:
	if state == TurnState.PLAYER_PLAYS_CARD:
		if current_skirmish.playerCard != null:
			print("Player locked in card: ", current_skirmish.playerCard.name)
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
	var card = player_hand.get_child(0)
	player_hand.remove_child(card)
	current_skirmish.playerCard = card

	skirmish_display.update_display(skirmishes)
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
		skirmish_display.update_display(skirmishes)
		print("Waiting to compare cards...")
		# TODO: Automatically advance to COMPARE_CARDS when ready
		advance(TurnState.COMPARE_CARDS)
	else:
		print("NPC has no cards, Player wins")
		player_score = WIN_SCORE
		advance(TurnState.CHECK_END_CONDITION)

func _compare_cards() -> void:
	print("Comparing cards")
	print(current_skirmish)
	var p_strength = current_skirmish.playerCard.power
	var n_strength = current_skirmish.opponentCard.power
	print("Player card strength: ", p_strength, " NPC card strength: ", n_strength)
	
	var winner = null
	if p_strength > n_strength:
		winner = current_skirmish.playerCard
	elif n_strength > p_strength:
		winner = current_skirmish.opponentCard

	if winner != null:
		var newPoint = AwardedPoint.instantiate()
		winner.add_child(newPoint)

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
