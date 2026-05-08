extends CardState

var played: bool

func enter() -> void:
	card_ui.color.color = Color.DARK_VIOLET
	card_ui.state.text = "Released"

	played = false
	
	if not card_ui.targets.is_empty():
		played = true
		var target_area := card_ui.targets[0] as Area2D
		if target_area:
			var maybe_drop_zone := target_area.get_parent()
			if maybe_drop_zone is CardDropZone:
				(maybe_drop_zone as CardDropZone).handle_card_dropped(card_ui)
		
func on_input(_event: InputEvent) -> void:
	if played: 
		return

	transition_requested.emit(self, CardState.State.BASE)
