@tool
class_name BagMenuBehaviour extends Node

func get_stack(items: Array[ItemStackMenuItem], current_index: int) -> ItemStack:
	if current_index < 0 || current_index >= items.size():
		return null

	return items[current_index].stack

func next(items: Array[ItemStackMenuItem], current_index: int) -> int:
	if items.size() <= 0:
		return current_index

	return (current_index + 1) % items.size()

func previous(items: Array[ItemStackMenuItem], current_index: int) -> int:
	if items.size() <= 0:
		return current_index

	# this weird maths ensures we wrap around to the bottom of the bag
	# if we're currently at the top of it
	return (current_index + items.size() - 1) % items.size()
