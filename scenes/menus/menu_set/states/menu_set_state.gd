class_name MenuSetState
extends Node

signal state_transition_requested(new_state: MenuSet.State, state_data: MenuSetStateData)

var _menu_set: MenuSet = null
var _state_data: MenuSetStateData = null
var _child_menus: Array[Menu] = []

func setup(
	menu_set: MenuSet,
	state_data: MenuSetStateData,
	child_menus: Array[Menu],
) -> void:
	_menu_set = menu_set
	_state_data = state_data
	_child_menus = child_menus

func transition_state(
	new_state: MenuSet.State,
	state_data := MenuSetStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

func _emit_opened() -> void:
	_menu_set.emit_opened()

func _emit_closed() -> void:
	_menu_set.emit_closed()
