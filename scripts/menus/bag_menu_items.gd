class_name BagMenuItems extends Node

@export
var index_handler: ListIndexHandler

var _menu_items: Array[ItemStackMenuItem]

func get_stack() -> ItemStack:
	if index_handler.current > -1 and index_handler.current <= get_max_index():
		return _menu_items[index_handler.current].stack

	return null

func size() -> int:
	return _menu_items.size()

func get_max_index() -> int:
	return size() - 1

func assign_stack(stack: ItemStack, index: int) -> void:
	_menu_items[index].stack = stack

func add_item(item: ItemStackMenuItem) -> void:
	_menu_items.append(item)

func get_item_y_pos(index: int) -> float:
	if index < 0:
		return 0

	return _menu_items[index].position.y

func trim_to(trim_size: int) -> void:
	for j in range(trim_size, size()):
		_menu_items[j].queue_free()

	while size() > trim_size:
		_menu_items.pop_back()

func highlight_current() -> void:
	for button in _menu_items:
		if button.index == index_handler.current:
			button.select()
		else:
			button.deselect()

func disable() -> void:
	for x in _menu_items:
		x.disable_item()

func enable() -> void:
	for x in _menu_items:
		x.enable_item()
