class_name UIManager extends Node

@export
var root_menu_set: MenuSet

signal ui_ready
signal menu_opened
signal menu_closed

func _ready() -> void:
	if root_menu_set:
		root_menu_set.opened.connect(menu_opened.emit)
		root_menu_set.closed.connect(menu_closed.emit)

		root_menu_set.to_hidden()

	ui_ready.emit()
