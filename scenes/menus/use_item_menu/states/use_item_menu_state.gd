class_name UseItemMenuState
extends Node

signal state_transition_requested(new_state: UseItemMenu.State, state_data: UseItemMenuStateData)

var _menu: UseItemMenu = null
var _state_data: UseItemMenuStateData = null
var _toggle_menu_input_handler: ToggleMenuInputHandler = null

func setup(
	menu: UseItemMenu,
	state_data: UseItemMenuStateData,
	toggle_menu_input_handler: ToggleMenuInputHandler,
) -> void:
	_menu = menu
	_state_data = state_data
	_toggle_menu_input_handler = toggle_menu_input_handler

func transition_state(
	new_state: UseItemMenu.State,
	state_data := UseItemMenuStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

func _emit_menu_hidden() -> void:
	_menu.emit_menu_hidden()

func _emit_menu_shown() -> void:
	_menu.emit_menu_shown()

func is_closed() -> bool:
	return false
