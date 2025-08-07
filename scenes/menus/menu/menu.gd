@tool
class_name Menu extends Control

enum State { ENABLED }

@onready
var menu_state_handler: MenuStateHandler = %MenuStateHandler

signal cancel

signal menu_hidden(menu: Menu)
signal menu_shown(menu: Menu)

signal steal_control(menu: Menu)

func cancel_menu() -> void:
	cancel.emit()

func disable_menu() -> void:
	print("Disabling menu " + name)

	menu_state_handler.disable()

func enable_menu() -> void:
	print("Enabling menu " + name)

	menu_state_handler.enable()

func cover_menu() -> void:
	print("Covering menu " + name)

	menu_state_handler.cover()

func uncover_menu() -> void:
	print("Uncovering menu " + name)

	menu_state_handler.uncover()

func steal() -> void:
	enable_menu()
	uncover_menu()

	steal_control.emit(self)

func is_closed() -> bool:
	return menu_state_handler.is_closed()

func is_covered() -> bool:
	return menu_state_handler.is_covered()

func _handle_visibility_changed() -> void:
	if is_visible_in_tree():
		menu_shown.emit(self)
	else:
		menu_hidden.emit(self)

	after_visibility_changed()

func after_visibility_changed() -> void:
	pass
