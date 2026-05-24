extends Node

enum TurnState {
	START_OF_TURN,
	PLAYER_PLAYS_CARD,
	NPC_PLAYS_CARD,
	COMPARE_CARDS,
	CONFIRM_ACTIVATE_ABILITY,
	RECALCULATE,
	CHECK_END_CONDITION
}

const AwardedPoint: PackedScene = preload("res://scenes/awarded_point.tscn")
const DeckLoader = preload("res://scenes/deck/deck_loader.gd")

var skirmishes: Array[Skirmish] = []
var state: TurnState = TurnState.START_OF_TURN

var player_score: int = 0
var npc_score: int = 0
var player_hand: Hand
var player_deck: Deck
var npc_hand: Hand
var npc_deck: Deck
var skirmish_display: SkirmishDisplay
var play_cards_button: Button
var state_label: Label
var player_card_selected: bool = false
const WIN_SCORE = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Initializing Game")
	var root_scene = get_tree().current_scene
	state_label = root_scene.get_node("Game/StateLabel") as Label
	play_cards_button = root_scene.get_node("Game/PlayCardsButton") as Button
	play_cards_button.pressed.connect(_on_play_cards_button_pressed)

	player_deck = _load_deck(("res://scenes/deck/deck.json"))
	player_hand = root_scene.get_node("Game/Player Hand") as Hand

	npc_deck = _load_deck(("res://scenes/deck/deck.json"))
	npc_hand = root_scene.get_node("Game/NPC Hand") as Hand

	skirmish_display = root_scene.get_node("Game/SkirmishDisplay") as SkirmishDisplay
	
	player_hand.cardList = player_deck.draw(5)
	npc_hand.cardList = npc_deck.draw(5)
	print("Player deck initialized with ", player_hand.cardList[0].power, " cards.")
	# Populate hands with fake cards
	# var card_scene = preload("res://scenes/card/card_ui.tscn")
	
	
	# Initialize 3 test skirmishes
	# for i in range(1, 4):
		# var test_skirmish = Skirmish.new()
		
		# # Create player card
		# var player_card = card_scene.instantiate()
		# player_card.card_name = "player %d" % i
		# player_card.power = i * 2
  
		# test_skirmish.playerCard = player_card
		
		# Create NPC card
		# var npc_card = CardUI.new( i * 3,null, "npc %d" % i)
		# npc_card.card_name = "npc %d" % i
		# npc_card.power = i * 3
		# test_skirmish.opponentCard = npc_card
		# skirmishes.append(test_skirmish)
		
		# Set winner based on strength
		# if player_card.strength > npc_card.strength:
			# test_skirmish.winner = "player"
		# elif npc_card.strength > player_card.strength:
			# test_skirmish.winner = "npc"
		# else:
			# test_skirmish.winner = "tie"
	# skirmish_display.update_display(skirmishes)
	
	call_deferred("advance", TurnState.START_OF_TURN)
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
		if skirmishes.back().playerCard != null:
			print("Player locked in card: ", skirmishes.back().playerCard.name)
			advance(TurnState.NPC_PLAYS_CARD)
		else:
			print("Player has no cards, NPC wins")
			npc_score = WIN_SCORE
			advance(TurnState.CHECK_END_CONDITION)
	
func _process_state() -> void:
	update_display()
	match state:
		TurnState.START_OF_TURN:
			_start_of_turn()
		
		TurnState.PLAYER_PLAYS_CARD:
			_player_plays_card()
			
		TurnState.NPC_PLAYS_CARD:
			_npc_plays_card()
			
		TurnState.COMPARE_CARDS:
			_compare_cards()
			
		TurnState.CONFIRM_ACTIVATE_ABILITY:
			_confirm_activate_ability()
			
		TurnState.RECALCULATE:
			_recalculate()
			
		TurnState.CHECK_END_CONDITION:
			_check_end_condition()

func _start_of_turn() -> void:
	print("Start of turn")
	skirmishes.append(Skirmish.new())
	print("Moving to player card selection...")

	# Temp play left most card. In the future, this will be replaced by player input to select a card.
	var card = player_hand.get_child(0)
	player_hand.remove_child(card)
	skirmishes.back().playerCard = card

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
		skirmishes.back().opponentCard = card
		npc_hand.remove_child(card)
		skirmish_display.update_display(skirmishes)
		print("Waiting to compare cards...")
		if skirmishes.back().playerCard != null && skirmishes.back().opponentCard != null:
			advance(TurnState.COMPARE_CARDS)
		else:
			print("Error: Missing card for comparison")
	else:
		print("NPC has no cards, Player wins")
		player_score = WIN_SCORE
		advance(TurnState.CHECK_END_CONDITION)

func _compare_cards() -> void:
	print("Comparing cards")
	print(skirmishes.back())
	var p_strength = skirmishes.back().playerCard.power
	var n_strength = skirmishes.back().opponentCard.power
	print("Player card strength: ", p_strength, " NPC card strength: ", n_strength)
	
	if p_strength > n_strength:
		skirmishes.back().playerCard.award_point()
		skirmishes.back().opponentCard.activate_ability()
		call_deferred("_deffered_enter_recalculate_state")
	elif n_strength > p_strength:
		skirmishes.back().opponentCard.award_point()
		skirmishes.back().playerCard.activate_ability()
		advance(TurnState.CONFIRM_ACTIVATE_ABILITY)
	else:
		call_deferred("_deffered_enter_recalculate_state")


func _confirm_activate_ability() -> void:
	print("Confirming ability activation")
	# For now, just automatically activate the ability
	#advance(TurnState.RECALCULATE)

func _award_point() -> void:
	print("Awarding point")
	if skirmishes.back().winner == "player":
		player_score += 1
		print("Player score: ", player_score)
	elif skirmishes.back().winner == "npc":
		npc_score += 1
		print("NPC score: ", npc_score)
	else:
		print("Tie, no point awarded")
	print("Waiting to activate ability...")
	# TODO: Automatically advance to ACTIVATE_ABILITY when ready
	# advance(TurnState.ACTIVATE_ABILITY)

func _activate_ability() -> void:
	print("Activating ability")
	if skirmishes.back().winner == "player":
		skirmishes.back().opponentCard.activate_ability()
	elif skirmishes.back().winner == "npc":
		skirmishes.back().playerCard.activate_ability()
	else:
		print("No ability activated due to tie")
	print("Waiting to recalculate...")
	# TODO: Automatically advance to RECALCULATE when ready
	call_deferred("_deffered_enter_recalculate_state")

func _deffered_enter_recalculate_state() -> void:
	advance(TurnState.RECALCULATE)

func _recalculate() -> void:
	var player_wins = 0
	var npc_wins = 0

	print("Recalculating")
	for skirmish in skirmishes:
		if skirmish.playerCard != null and skirmish.opponentCard != null:
			print(skirmish.playerCard.power, " vs ", skirmish.opponentCard.power)
			if skirmish.playerCard.power > skirmish.opponentCard.power:
				skirmish.playerCard.award_point()
				skirmish.opponentCard.remove_point()
				player_wins += 1
			elif skirmish.playerCard.power < skirmish.opponentCard.power:
				skirmish.opponentCard.award_point()
				skirmish.playerCard.remove_point()
				npc_wins += 1
			else:
				skirmish.playerCard.remove_point()
				skirmish.opponentCard.remove_point()

	if player_score >= WIN_SCORE:
		print("Player wins the game!")
	elif npc_score >= WIN_SCORE:
		print("NPC wins the game!")
	else:
		print("Continuing to next turn")
		advance(TurnState.START_OF_TURN)

func _check_end_condition() -> void:
	print("Checking end condition")
	if player_score >= WIN_SCORE:
		print("Player wins the game!")
	elif npc_score >= WIN_SCORE:
		print("NPC wins the game!")
	else:
		print("Continuing to next turn")
		advance(TurnState.START_OF_TURN)

func _load_deck(path: String) -> Deck:
	var cardDataArray = DeckLoader.initialize_deck(path)
	var new_deck = Deck.new()
	for cardData in cardDataArray:
		var card = CardUI.new(cardData)
		new_deck.cardList.append(card)
	return new_deck

func update_display() -> void:
	player_hand.update_display()
	npc_hand.update_display()
	skirmish_display.update_display(skirmishes)
