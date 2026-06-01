class_name CardDropZone
extends Control

@onready var drop_zone: Area2D = $DropZone

@export var is_active: bool = false:
	set(value):
		is_active = value
		if is_node_ready():
			drop_zone.monitorable = value
			drop_zone.monitoring = value

signal area_entered(area: Area2D)
signal area_exited(area: Area2D)

func _ready() -> void:
	# Set initial state
	drop_zone.monitorable = is_active
	drop_zone.monitoring = is_active


func _on_drop_zone_area_entered(area: Area2D) -> void:
	if is_active:
		area_entered.emit(area)


func _on_drop_zone_area_exited(area: Area2D) -> void:
	if is_active:
		area_exited.emit(area)


# func handle_card_dropped(card_ui: CardUI) -> void:
# 	print("Card was")
# 	card_dropped.emit(card_ui)
