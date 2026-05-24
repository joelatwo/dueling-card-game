extends Node
class_name DeckLoader

static func load_deck(path: String) -> Array:
	var text := FileAccess.get_file_as_string(path)
	var parse_result = JSON.parse_string(text)
	if parse_result == null:
		push_error("Failed to load deck '%s'" % [path])
		return []

	if parse_result.has("cards"):
		return parse_result["cards"]
	if parse_result.has("deck"):
		return parse_result["deck"]

	push_error("Deck file '%s' does not contain a 'cards' or 'deck' array." % path)
	return []

static func randomize(deck: Array) -> Array:
	var randomized_deck = deck.duplicate()
	randomized_deck.shuffle()
	return randomized_deck

static func initialize_deck(path: String) -> Array:
	var randomized_deck = load_deck(path)
	randomized_deck.shuffle()
	return randomized_deck
