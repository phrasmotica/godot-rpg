@tool
class_name ListMenuInputHandler extends Node

@export
var menu_nav: GUIDEAction

@export
var menu_select: GUIDEAction

signal next
signal previous
signal select

func _ready():
	menu_nav.triggered.connect(_handle_menu_nav)
	menu_select.triggered.connect(select.emit)

func _handle_menu_nav() -> void:
	var dir := menu_nav.value_axis_2d

	if dir == Vector2.DOWN:
		next.emit()

	if dir == Vector2.UP:
		previous.emit()
