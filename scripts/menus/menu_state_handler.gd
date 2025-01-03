class_name MenuStateHandler extends Node2D

enum MenuState { CLOSED, INACTIVE, ACTIVE, COVERED }

var _inactive := false
var _covered := false

func is_closed() -> bool:
	return get_menu_state() == MenuState.CLOSED

func is_covered() -> bool:
	return get_menu_state() == MenuState.COVERED

func can_listen() -> bool:
	return get_menu_state() == MenuState.ACTIVE

func disable() -> void:
	_inactive = true

func enable() -> void:
	_inactive = false

func cover() -> void:
	_covered = true

func uncover() -> void:
	_covered = false

func get_menu_state() -> MenuState:
	if not is_visible_in_tree():
		return MenuState.CLOSED

	if _covered:
		return MenuState.COVERED

	if _inactive:
		return MenuState.INACTIVE

	return MenuState.ACTIVE
