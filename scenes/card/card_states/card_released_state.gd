extends CardState

var played: bool

# Card Played
func enter() -> void:
	print("Card was played in the card_released_sate")
	card_ui.color.color = Color.DARK_VIOLET
	card_ui.state.text = "Released"

	played = false
	print(card_ui.targets)
	
	if not card_ui.targets.is_empty():
		print("Playing card with targets")
		play_card()
	else:
		print("Canceling Card")
		undo_play_card()

func on_input(_event: InputEvent) -> void:
	if played: 
		return

	transition_requested.emit(self, CardState.State.BASE)

func play_card() -> void:
	print("targeting", card_ui.targets)
	played = true
	var target_area := card_ui.targets[0] as Area2D
	if target_area:
		var maybe_drop_zone := target_area.get_parent()
		if maybe_drop_zone is CardDropZone:
			print("Emitting card dropped signal")
			SignalBus.card_dropped.emit(card_ui)

func undo_play_card() -> void:
	var parent = card_ui.get_parent()
	parent.remove_child(card_ui)
	parent.add_child(card_ui)
	transition_requested.emit(self, CardState.State.BASE)
