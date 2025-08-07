class_name MenuSetStateEnabled
extends MenuSetState

func _enter_tree() -> void:
	print("MenuSet is now enabled")

	_menu_set.show()

	_emit_opened()

	if Engine.is_editor_hint():
		return

	_menu_set.refresh()

	_toggle_menu_input_handler.toggled.connect(_handle_toggle_menu)
	_menu_set.menu_nav_action.triggered.connect(_handle_menu_nav)

func _handle_toggle_menu() -> void:
	transition_state(MenuSet.State.HIDDEN)

func _handle_menu_nav() -> void:
	_menu_set.handle_menu_nav()
