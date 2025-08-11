@tool
class_name BagMenuBehaviour extends Node

# TODO: turn this into a non-Node script

@export_group("Dependencies")

@export
var menu_items: BagMenuItems

@export
var index_handler: ListIndexHandler

signal current_index_changed(index: int)

func _ready() -> void:
	index_handler.current_index_changed.connect(current_index_changed.emit)

func clamp() -> void:
	if menu_items.size() > 0:
		index_handler.clamp(menu_items.get_max_index())

func get_item_stack() -> ItemStack:
	return menu_items.get_stack()

func get_item() -> Item:
	var stack := get_item_stack()
	return stack.get_item() if stack else null

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
