extends Node2D

@onready var countLabel: Label = get_node("Count") as Label

func onready () -> void:
	update()

func update() -> void:
	var deckSize = get_parent().cardList.size()
	countLabel.text = str(deckSize)
