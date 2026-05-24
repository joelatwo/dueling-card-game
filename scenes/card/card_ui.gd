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
@onready var targets: Array[Node] = []
@onready var CardAbilityClass: CardAbility = CardAbility.new()

@onready var power: int = 0
var ability_text: String = ""
var card_name: String = ""

func _init(props):
	power = props.get("Power", 0)
	ability_text = props.get("AbilityText", "")
	card_name = props.get("name", "")
	print("Initialized card with name: ", card_name, " power: ", power, " ability text: ", ability_text)
	update_display()
	# power_label.text = str(power)
	# name_label.text = str(card_name)
	# ability_text_label.text = str(ability_text)
	# card_state_machine.init(self)
	

func activate_ability():
	var ability_functions: Array = self.get_meta("AbilityFunctionList")
	for func_name in ability_functions:
		CardAbilityClass.call(func_name, self)
		print("Activated ability function: ", func_name)

# func _ready() -> void:
	# print(self.get_meta_list())

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

func update_display() -> void:
	power_label.text = str(power)
	name_label.text = card_name
	ability_text_label.text = str(ability_text)
