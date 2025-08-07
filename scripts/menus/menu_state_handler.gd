@tool
class_name MenuStateHandler extends Node

# HIGH: create a state machine for the Menu script, which should replace this...

enum State { CLOSED, INACTIVE, ACTIVE, COVERED }

@export
var menu: Menu

var _inactive := false
var _covered := false

func is_closed() -> bool:
	return get_menu_state() == State.CLOSED

func is_covered() -> bool:
	return get_menu_state() == State.COVERED

func can_listen() -> bool:
	return get_menu_state() == State.ACTIVE

func disable() -> void:
	_inactive = true

func enable() -> void:
	_inactive = false

func cover() -> void:
	_covered = true

func uncover() -> void:
	_covered = false

func get_menu_state() -> State:
	if not menu.is_visible_in_tree():
		return State.CLOSED

	if _covered:
		return State.COVERED

	if _inactive:
		return State.INACTIVE

	return State.ACTIVE
