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
const WIN_SCORE = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Initializing Game")
	var root_scene = get_tree().current_scene
	player_hand = root_scene.get_node("Game/Player Hand") as Hand
	npc_hand = root_scene.get_node("Game/NPC Hand") as Hand
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
	_process_state()
	
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
	advance(TurnState.PLAYER_PLAYS_CARD)

func _player_plays_card() -> void:
	print("Player plays card")
	if player_hand.get_child_count() > 0:
		var card = player_hand.get_child(0)
		player_hand.remove_child(card)
		current_skirmish.playerCard = card
		advance(TurnState.NPC_PLAYS_CARD)
	else:
		print("Player has no cards, NPC wins")
		npc_score = WIN_SCORE
		advance(TurnState.CHECK_END_CONDITION)

func _npc_plays_card() -> void:
	print("NPC plays card")
	if npc_hand.get_child_count() > 0:
		var card = npc_hand.get_child(0)
		npc_hand.remove_child(card)
		current_skirmish.opponentCard = card
		advance(TurnState.COMPARE_CARDS)
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
	advance(TurnState.AWARD_POINT)

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
	advance(TurnState.ACTIVATE_ABILITY)

func _activate_ability() -> void:
	print("Activating ability")
	if current_skirmish.winner == "player":
		current_skirmish.opponentCard.activate_ability()
	elif current_skirmish.winner == "npc":
		current_skirmish.playerCard.activate_ability()
	else:
		print("No ability activated due to tie")
	advance(TurnState.RECALCULATE)

func _recalculate() -> void:
	print("Recalculating")
	print("Player and NPC draw 1 card")
	# For now, no recalculation needed
	advance(TurnState.CHECK_END_CONDITION)

func _check_end_condition() -> void:
	print("Checking end condition")
	if player_score >= WIN_SCORE:
		print("Player wins the game!")
	elif npc_score >= WIN_SCORE:
		print("NPC wins the game!")
	else:
		print("Continuing to next turn")
		advance(TurnState.START_OF_TURN)
