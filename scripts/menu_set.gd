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

func after_ready():
	if menus.size() > 0:
		current_menu_index = 0

	for i in range(menus.size()):
		var menu = menus[i]

		menu.menu_disabled.connect(
			func(m):
				print(m.name + " disabled, disabling " + name)
				menu_dimmers[i].is_dimmed = true
		)

		menu.menu_enabled.connect(
			func(m):
				print(m.name + " enabled, enabling " + name)
				menu_dimmers[i].is_dimmed = false
		)

func listen_for_inputs():
	if Input.is_action_just_pressed("menu_set_cycle_next"):
		current_menu_index = ((current_menu_index + 1) % menus.size())

	if Input.is_action_just_pressed("menu_set_cycle_previous"):
		current_menu_index = ((current_menu_index + menus.size() - 1) % menus.size())

func _get_configuration_warnings():
	if menus.size() != menu_dimmers.size():
		return ["Menu count and dimmer count must be the same!"]

	return []
