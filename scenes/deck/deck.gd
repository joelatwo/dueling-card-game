extends Node2D
class_name Deck

const CARD_BACK_SCENE: PackedScene = preload("res://scenes/card/card_back.tscn")
const EMPTY_DECK_SCENE: PackedScene = preload("res://scenes/deck/empty_deck.tscn")

var cardList: Array[CardUI] = []

func onready () -> void:
	print("Ready with cardList", cardList.size())
	refresh()

func update_display(new_items: Array) -> void:
	cardList = new_items
	clear_display()
	refresh()

func clear_display() -> void:
	for child in self.get_children():
		self.remove_child(child)
	
func refresh() -> void:
	var deckLength = cardList.size()
	if (deckLength > 0):
		print("Deck has ", deckLength, " cards.")
		var cardBack = CARD_BACK_SCENE.instantiate()
		add_child(cardBack)
	else:
		var emptyDeck = EMPTY_DECK_SCENE.instantiate()
		add_child(emptyDeck)

func draw(numberOfCards: int) -> Array[CardUI]:
	var drawnCards: Array[CardUI] = []
	for i in range(numberOfCards):
		if cardList.size() > 0:
			var drawnCard = cardList.pop_back()
			drawnCards.append(drawnCard)
	return drawnCards
