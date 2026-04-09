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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Initializing Game")
	for child in get_children():
		print(child)
	#print(skirmishes.size())
	advance(TurnState.PLAYER_PLAYS_CARD)
	print("card 1")
	pass # Replace with function body.

func advance(next_state: TurnState) -> void:
	state = next_state
	_process_state()
	
func _process_state() -> void:
	match state:
		TurnState.START_OF_TURN:
			print("start of turn")
		
		TurnState.PLAYER_PLAYS_CARD:
			print("player plays card")
			
		TurnState.NPC_PLAYS_CARD:
			print("npc plays card")
			
		TurnState.COMPARE_CARDS:
			print("comparing cards")
			
		TurnState.AWARD_POINT:
			print("awarding point")

		TurnState.ACTIVATE_ABILITY:
			print("activating ability of loser")
			
		TurnState.RECALCULATE:
			print("do we need to change who won")
			
		TurnState.CHECK_END_CONDITION:
			print("did either player win")
			advance(TurnState.START_OF_TURN)
