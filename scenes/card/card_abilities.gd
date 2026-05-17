extends Node
class_name CardAbility

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func execute(user, target, game_state):
	push_error("Ability.execute() not implemented")

func increaseMyPower(card: CardUI, amount = 1):
	print(card.power)
	card.power += amount
	card.power_label.text = str(card.power)
