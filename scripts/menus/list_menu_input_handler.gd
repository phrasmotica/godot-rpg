@tool
class_name ListMenuInputHandler extends Node

@export_group("Input Actions")

@export
var menu_nav: GUIDEAction

@export
var menu_select: GUIDEAction

@export_group("Dependencies")

@export
var state_handler: MenuStateHandler

signal next
signal previous
signal select

func _ready():
	menu_nav.triggered.connect(_handle_menu_nav)
	menu_select.triggered.connect(_handle_menu_select)

func _handle_menu_nav() -> void:
	if not state_handler.can_listen():
		return

	var dir := menu_nav.value_axis_2d

	if dir == Vector2.DOWN:
		print("Moving to next item")

		next.emit()

	if dir == Vector2.UP:
		print("Moving to previous item")

		previous.emit()

func _handle_menu_select() -> void:
	if not state_handler.can_listen():
		return

	select.emit()
