@tool
class_name MenuSet extends Menu

@export
var current_menu_index := -1:
	set(value):
		var new_index: int = max(-1, min(menus.size() - 1, value))
		var index_changed := current_menu_index != new_index

		current_menu_index = new_index

		if index_changed:
			for i in range(menu_dimmers.size()):
				menu_dimmers[i].is_dimmed = i != current_menu_index

@export
var menus: Array[Menu] = []:
	set(value):
		menus = value
		update_configuration_warnings()

@export
var menu_dimmers: Array[Dimmer] = []:
	set(value):
		menu_dimmers = value
		update_configuration_warnings()

@export
var menu_nav_action: GUIDEAction

func after_ready():
	if menus.size() > 0:
		current_menu_index = 0

	for i in range(menus.size()):
		var menu = menus[i]

		menu.menu_disabled.connect(
			func(m):
				menu_dimmers[i].is_dimmed = true

				print(m.name + " disabled, disabling " + name)
				disable_menu()
		)

		menu.menu_enabled.connect(
			func(m):
				menu_dimmers[i].is_dimmed = false

				print(m.name + " enabled, enabling " + name)
				enable_menu()
		)

	menu_nav_action.triggered.connect(handle_menu_nav)

func handle_menu_nav() -> void:
	# MEDIUM: allow cycling the positions of each menu in the set
	# as the selected menu changes
	var dir := menu_nav_action.value_axis_2d

	if dir == Vector2.RIGHT:
		current_menu_index = ((current_menu_index + 1) % menus.size())

	if dir == Vector2.LEFT:
		current_menu_index = ((current_menu_index + menus.size() - 1) % menus.size())

func _get_configuration_warnings():
	if menus.size() != menu_dimmers.size():
		return ["Menu count and dimmer count must be the same!"]

	return []
