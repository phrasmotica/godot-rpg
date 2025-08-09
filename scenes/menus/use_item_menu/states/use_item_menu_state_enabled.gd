class_name UseItemMenuStateEnabled
extends UseItemMenuState

func _enter_tree() -> void:
	print("%s is now enabled" % _menu.name)

	_menu.show()

	_toggle_menu_input_handler.toggled.connect(_handle_toggle_menu)

	_emit_menu_shown()

func _handle_toggle_menu() -> void:
	print("Hiding UseItemMenu")

	transition_state(UseItemMenu.State.DISABLED)
