class_name MenuSetStateHidden
extends MenuSetState

func _enter_tree() -> void:
	print("MenuSet is now hidden")

	_menu_set.hide()

	_emit_closed()

	_toggle_menu_input_handler.toggled.connect(_handle_toggle_menu)

func _handle_toggle_menu() -> void:
	transition_state(MenuSet.State.ENABLED)
