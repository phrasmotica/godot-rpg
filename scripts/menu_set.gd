@tool
class_name MenuSet extends Control

@export
var current_menu_index := -1:
	set(value):
		var new_index: int = max(-1, min(menus.size() - 1, value))
		var index_changed := current_menu_index != new_index

		# MEDIUM: allow cycling the positions of each menu in the set
		# as the selected menu changes
		current_menu_index = new_index

		if index_changed:
			for i in range(menus.size()):
				if i != current_menu_index:
					menus[i].disable_menu()
				else:
					menus[i].enable_menu()

@export
var menus: Array[Menu] = []

@export
var toggle_bag_menu_input_handler: ToggleBagMenuInputHandler

@export
var menu_nav_action: GUIDEAction

var _child_is_enabled := false

signal cancel

func _ready():
	if menus.size() > 0:
		current_menu_index = 0

	if Engine.is_editor_hint():
		return

	toggle_bag_menu_input_handler.toggled.connect(_handle_toggle_bag_menu)

	menu_nav_action.triggered.connect(_handle_menu_nav)

	for i in range(menus.size()):
		menus[i].menu_disabled.connect(_handle_child_menu_disabled)
		menus[i].menu_enabled.connect(_handle_child_menu_enabled)

func _handle_toggle_bag_menu() -> void:
	if _can_listen():
		cancel.emit()

func _handle_menu_nav() -> void:
	if not _can_listen():
		return

	var dir := menu_nav_action.value_axis_2d

	if dir == Vector2.RIGHT:
		current_menu_index = ((current_menu_index + 1) % menus.size())

	if dir == Vector2.LEFT:
		current_menu_index = ((current_menu_index + menus.size() - 1) % menus.size())

func _handle_child_menu_disabled(menu: Menu) -> void:
	print(menu.name + " disabled, disabling parent set " + name)

	_child_is_enabled = true

func _handle_child_menu_enabled(menu: Menu) -> void:
	print(menu.name + " enabled, enabling parent set " + name)

	_child_is_enabled = false

func _can_listen():
	return not _child_is_enabled and is_visible_in_tree()
