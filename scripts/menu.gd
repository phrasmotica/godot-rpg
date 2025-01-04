@tool
class_name Menu extends Control

@export
var toggle_bag_menu_input_handler: ToggleBagMenuInputHandler

@onready
var menu_state_handler: MenuStateHandler = %MenuStateHandler

signal cancel

signal menu_hidden(menu: Menu)
signal menu_shown(menu: Menu)

signal steal_control(menu: Menu)

func _ready():
	if Engine.is_editor_hint():
		return

	toggle_bag_menu_input_handler.toggled.connect(_handle_toggle_bag_menu)

func _handle_toggle_bag_menu() -> void:
	if menu_state_handler.can_listen():
		cancel_menu()

func cancel_menu():
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

func steal():
	enable_menu()
	uncover_menu()

	steal_control.emit(self)

func is_closed() -> bool:
	return menu_state_handler.is_closed()

func is_covered() -> bool:
	return menu_state_handler.is_covered()

func _on_visibility_changed():
	if is_visible_in_tree():
		menu_shown.emit(self)
	else:
		menu_hidden.emit(self)

	after_visibility_changed()

func after_visibility_changed():
	pass
