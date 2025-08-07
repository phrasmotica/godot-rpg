class_name MenuState
extends Node

signal state_transition_requested(new_state: Menu.State, state_data: MenuStateData)

var _menu: Menu = null
var _state_data: MenuStateData = null

func setup(
	menu: Menu,
	state_data: MenuStateData,
) -> void:
	_menu = menu
	_state_data = state_data

func transition_state(
	new_state: Menu.State,
	state_data := MenuStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)
