extends PanelContainer

@onready var card_drop_zone: CardDropZone = $CardDropZone

# func _ready() -> void:
	# card_drop_zone.card_dropped.connect(_on_card_dropped)

func _on_card_dropped(card_ui: CardUI) -> void:
	var p := get_parent()
	if p and p.has_method("place_card"):
		p.call("place_card", card_ui)
