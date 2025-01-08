@tool
class_name BagMenuBehaviour extends Node

@export_group("Dependencies")

@export
var menu_items: BagMenuItems

@export
var index_handler: ListIndexHandler

func next() -> void:
	if menu_items.size() <= 0:
		return

	index_handler.update((index_handler.current + 1) % menu_items.size())

func previous() -> void:
	if menu_items.size() <= 0:
		return

	# this weird maths ensures we wrap around to the bottom of the bag
	# if we're currently at the top of it
	index_handler.update((index_handler.current + menu_items.size() - 1) % menu_items.size())
