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
			_refresh()

@export
var menus: Array[Menu] = []

@export
var toggle_menu_input_handler: ToggleMenuInputHandler

@export
var menu_nav_action: GUIDEAction

signal cancel

func _ready() -> void:
	if menus.size() > 0:
		current_menu_index = 0

	if Engine.is_editor_hint():
		return

	visibility_changed.connect(_refresh)

	toggle_menu_input_handler.toggled.connect(_handle_toggle_menu)

	menu_nav_action.triggered.connect(_handle_menu_nav)

	for m in menus:
		m.cancel.connect(cancel.emit)

func _refresh() -> void:
	for i in range(menus.size()):
		if i != current_menu_index:
			menus[i].disable_menu()
		else:
			menus[i].enable_menu()

func _handle_toggle_menu() -> void:
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

func _can_listen() -> bool:
	if not is_visible_in_tree():
		return false

	for menu in menus:
		if menu.is_covered():
			# another layer of menus is currently active
			return false

	return true
