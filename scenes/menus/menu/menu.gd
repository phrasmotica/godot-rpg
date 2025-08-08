@tool
class_name Menu extends Control

@onready
var menu_state_handler: MenuStateHandler = %MenuStateHandler

signal cancel

signal menu_hidden(menu: Menu)
signal menu_shown(menu: Menu)
signal menu_covered
signal menu_uncovered

signal steal_control(menu: Menu)

func cancel_menu() -> void:
	cancel.emit()

func disable_menu() -> void:
	pass

func enable_menu() -> void:
	pass

func cover_menu() -> void:
	pass

func uncover_menu() -> void:
	pass

func steal() -> void:
	_emit_steal_control()

func _emit_steal_control() -> void:
	steal_control.emit(self)

func emit_menu_hidden() -> void:
	menu_hidden.emit(self)

func emit_menu_shown() -> void:
	menu_shown.emit(self)

func emit_menu_covered() -> void:
	menu_covered.emit()

func emit_menu_uncovered() -> void:
	menu_uncovered.emit()

func is_closed() -> bool:
	return false

func _handle_visibility_changed() -> void:
	if is_visible_in_tree():
		menu_shown.emit(self)
	else:
		menu_hidden.emit(self)

	after_visibility_changed()

func after_visibility_changed() -> void:
	pass
