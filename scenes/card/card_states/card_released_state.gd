extends CardState

var played: bool

# Card Played
func enter() -> void:
	print("Card was played in the card_released_sate")
	card_ui.color.color = Color.DARK_VIOLET
	card_ui.state.text = "Released"

	played = false
	var overlapping_areas = card_ui.drop_point_detector.get_overlapping_areas()
	for area in overlapping_areas:
		if(area.name == "CardPlayedConfirmDropZone"):
			play_card()
			return

	undo_play_card()
	
func on_input(_event: InputEvent) -> void:
	if played:
		return

	transition_requested.emit(self , CardState.State.BASE)

func play_card() -> void:
	SignalBus.card_dropped.emit(card_ui)

func undo_play_card() -> void:
	var parent = card_ui.get_parent()
	parent.remove_child(card_ui)
	parent.add_child(card_ui)
	transition_requested.emit(self , CardState.State.BASE)
