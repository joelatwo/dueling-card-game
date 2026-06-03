class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)
const AwardedPoint: PackedScene = preload("res://scenes/awarded_point.tscn")

@onready var color: ColorRect = $Color
@onready var state: Label = $State
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var power_label: Label = $Power
@onready var name_label: Label = $Name
@onready var ability_text_label: Label = $Ability
@onready var PointsAwardedArea: BoxContainer = $PointsAwardedArea
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var CardAbilityClass: CardAbility = CardAbility.new()

var dragging := false
var drag_offset := Vector2.ZERO
var power: int = 0
var ability_text: String = ""
var card_name: String = ""

func setup(props):
	# { "power": 5.0, "abilityText": "Deal 2 damage to opponent", "name": "Fireball"}
	power = props.get("power", 0)
	ability_text = props.get("abilityText", "")
	card_name = props.get("name", "")
	# update_display()
	# card_state_machine.init(self)
	

func activate_ability():
	var ability_functions: Array = self.get_meta("AbilityFunctionList")
	for func_name in ability_functions:
		CardAbilityClass.call(func_name, self )

func _ready() -> void:
	call_deferred("update_display")
	card_state_machine.init(self )

func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)
	
func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)

func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()
	
func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()

func _card_dropped() -> void:
	print("Card dropped: ", self.name)

func award_point() -> void:
	var newPoint = AwardedPoint.instantiate()
	PointsAwardedArea.add_child(newPoint)

func remove_point() -> void:
	if PointsAwardedArea.get_child_count() > 0:
		PointsAwardedArea.get_child(PointsAwardedArea.get_child_count() - 1).queue_free()

func update_display() -> void:
	power_label.text = str(power)
	name_label.text = card_name
	ability_text_label.text = str(ability_text)
