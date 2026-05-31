class_name Hand
extends HBoxContainer

var cardList: Array[CardUI] = []

func update_display() -> void:
	clear_display()
	refresh()

func clear_display() -> void:
	for child in self.get_children():
		self.remove_child(child)
	
func refresh() -> void:
	for card in cardList:
		add_child(card)
