@tool
class_name Menu extends Control

@export
var toggle_bag_menu_input_handler: ToggleBagMenuInputHandler

var _inactive := false
var _covered := false

signal cancel

signal menu_hidden(menu: Menu)
signal menu_shown(menu: Menu)

signal menu_disabled(menu: Menu)
signal menu_enabled(menu: Menu)

signal steal_control(menu: Menu)

enum MenuState { CLOSED, INACTIVE, ACTIVE, COVERED }

func _ready():
	if Engine.is_editor_hint():
		return

	toggle_bag_menu_input_handler.toggled.connect(_handle_toggle_bag_menu)

	after_ready()

func after_ready():
	pass

func _handle_toggle_bag_menu() -> void:
	if can_listen():
		cancel_menu()

func can_listen():
	return get_menu_state() == MenuState.ACTIVE

func get_menu_state() -> MenuState:
	if not is_visible_in_tree():
		return MenuState.CLOSED

	if _inactive:
		return MenuState.INACTIVE

	if _covered:
		return MenuState.COVERED

	return MenuState.ACTIVE

func cancel_menu():
	cancel.emit()

func disable_menu():
	print("Disabling menu " + name)

	_inactive = true
	menu_disabled.emit(self)

func enable_menu():
	print("Enabling menu " + name)

	_inactive = false
	menu_enabled.emit(self)

func cover_menu() -> void:
	print("Covering menu " + name)

	_covered = true

func uncover_menu() -> void:
	print("Uncovering menu " + name)

	_covered = false

func steal():
	steal_control.emit(self)

func _on_visibility_changed():
	if is_visible_in_tree():
		menu_shown.emit(self)
	else:
		menu_hidden.emit(self)

	after_visibility_changed()

func after_visibility_changed():
	pass
