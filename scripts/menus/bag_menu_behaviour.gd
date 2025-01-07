@tool
class_name BagMenuBehaviour extends Node

@onready
var index_handler: ListIndexHandler = %ListIndexHandler

func get_stack(items: Array[ItemStackMenuItem]) -> ItemStack:
	if index_handler.current < 0 || index_handler.current >= items.size():
		return null

	return items[index_handler.current].stack

func next(items: Array[ItemStackMenuItem]) -> void:
	if items.size() <= 0:
		return

	index_handler.update((index_handler.current + 1) % items.size())

func previous(items: Array[ItemStackMenuItem]) -> void:
	if items.size() <= 0:
		return

	# this weird maths ensures we wrap around to the bottom of the bag
	# if we're currently at the top of it
	index_handler.update((index_handler.current + items.size() - 1) % items.size())
