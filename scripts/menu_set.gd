@tool
class_name MenuSet extends Menu

@export
var current_menu_index := -1:
	set(value):
		var new_index: int = max(-1, min(menu_dimmers.size() - 1, value))
		var index_changed := current_menu_index != new_index

		current_menu_index = new_index

		if index_changed:
			for i in range(menu_dimmers.size()):
				menu_dimmers[i].is_dimmed = i != current_menu_index

@export
var menu_dimmers: Array[Dimmer] = []

func after_ready():
	if menu_dimmers.size() > 0:
		current_menu_index = 0

func listen_for_inputs():
	if Input.is_action_just_pressed("menu_set_cycle_next"):
		current_menu_index = ((current_menu_index + 1) % menu_dimmers.size())

	if Input.is_action_just_pressed("menu_set_cycle_previous"):
		current_menu_index = ((current_menu_index + menu_dimmers.size() - 1) % menu_dimmers.size())
