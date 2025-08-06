class_name MenuSetState
extends Node

signal state_transition_requested(new_state: MenuSet.State, state_data: MenuSetStateData)

var _button: MenuSet = null
var _state_data: MenuSetStateData = null

func setup(
	button: MenuSet,
	state_data: MenuSetStateData,
) -> void:
	_button = button
	_state_data = state_data

func transition_state(
	new_state: MenuSet.State,
	state_data := MenuSetStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)
