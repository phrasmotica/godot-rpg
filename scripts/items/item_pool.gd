class_name ItemPool extends Node

@export
var items := {}

func get_random() -> Item:
	return items.values().pick_random()

func get_item(item_id: int) -> Item:
	var found_items := items.values().filter(
		func(i: Item):
			return i.id == item_id
	)

	if found_items.size() != 1:
		return null

	return found_items[0]
