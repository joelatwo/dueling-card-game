class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)
const AwardedPoint: PackedScene = preload("res://scenes/awarded_point.tscn")

@onready var color: ColorRect = $Color
@onready var state: Label = $State
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var power_label: Label = $Power
@onready var PointsAwardedArea: BoxContainer = $PointsAwardedArea
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var targets: Array[Node] = []
@onready var power: int = self.get("metadata/Power")

func activate_ability():
	print("Ability of ", name, " activated")

func _ready() -> void:
	power_label.text = str(power)
	card_state_machine.init(self )

func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)
	
func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)

func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()
	
func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()


func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)


func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)

func award_point() -> void:
	var newPoint = AwardedPoint.instantiate()
	PointsAwardedArea.add_child(newPoint)

func remove_point() -> void:
	if PointsAwardedArea.get_child_count() > 0:
		PointsAwardedArea.get_child(PointsAwardedArea.get_child_count() - 1).queue_free()
