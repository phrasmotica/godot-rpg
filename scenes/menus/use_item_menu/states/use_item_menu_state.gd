class_name UseItemMenuState
extends Node

signal state_transition_requested(new_state: UseItemMenu.State, state_data: UseItemMenuStateData)

var _menu: UseItemMenu = null
var _state_data: UseItemMenuStateData = null

func setup(
	menu: UseItemMenu,
	state_data: UseItemMenuStateData,
) -> void:
	_menu = menu
	_state_data = state_data

func transition_state(
	new_state: UseItemMenu.State,
	state_data := UseItemMenuStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)
