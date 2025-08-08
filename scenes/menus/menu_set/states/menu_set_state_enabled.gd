class_name MenuSetStateEnabled
extends MenuSetState

func _enter_tree() -> void:
	print("MenuSet is now enabled")

	_menu_set.show()

	_emit_opened()

	if Engine.is_editor_hint():
		return

	_menu_set.refresh()

	for m in _child_menus:
		m.menu_covered.connect(_on_child_menu_covered)

	_toggle_menu_input_handler.toggled.connect(_handle_toggle_menu)
	_menu_set.menu_nav_action.triggered.connect(_handle_menu_nav)

func _on_child_menu_covered() -> void:
	transition_state(MenuSet.State.DISABLED)

func _handle_toggle_menu() -> void:
	transition_state(MenuSet.State.HIDDEN)

func _handle_menu_nav() -> void:
	_menu_set.handle_menu_nav()
