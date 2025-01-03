@tool
class_name Menu extends Control

@export
var toggle_bag_menu_input_handler: ToggleBagMenuInputHandler

var _inactive := false

signal cancel

signal menu_hidden(menu: Menu)
signal menu_shown(menu: Menu)

signal menu_disabled(menu: Menu)
signal menu_enabled(menu: Menu)

signal steal_control(menu: Menu)

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
	return not _inactive and is_visible_in_tree()

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
