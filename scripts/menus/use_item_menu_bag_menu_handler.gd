class_name BagMenuHandler extends Node

@export
var next_frame_handler: NextFrameHandler

var _selected_item: Item

signal show_menu
signal selected_item_changed(item: Item)

func handle_select_stack(stack: ItemStack, should_close: bool) -> void:
	if should_close:
		# we're expecting the bag menu to close, so don't show the use item menu
		return

	next_frame_handler.on_next_frame(_show_menu.bind(stack))

func select_item(item: Item) -> void:
	_selected_item = item

	selected_item_changed.emit(_selected_item)

func _show_menu(stack: ItemStack) -> void:
	show_menu.emit(stack)
