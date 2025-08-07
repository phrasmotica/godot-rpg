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

func enable() -> void:
	pass

func disable() -> void:
	pass

func cover() -> void:
	pass

func uncover() -> void:
	pass

func steal() -> void:
	pass

func is_closed() -> bool:
	return false

func is_covered() -> bool:
	return false

func _emit_menu_shown() -> void:
	_menu.emit_menu_shown()

func _emit_menu_hidden() -> void:
	_menu.emit_menu_hidden()
