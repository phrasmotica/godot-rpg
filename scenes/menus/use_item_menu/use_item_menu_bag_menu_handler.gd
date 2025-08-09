class_name BagMenuHandler extends Node

var _selected_item: Item

signal selected_item_changed(item: Item)

func select_item(item: Item) -> void:
	_selected_item = item

	selected_item_changed.emit(_selected_item)
