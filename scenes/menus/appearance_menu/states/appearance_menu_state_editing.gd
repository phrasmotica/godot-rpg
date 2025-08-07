class_name AppearanceMenuStateEditing
extends AppearanceMenuState

func _enter_tree() -> void:
	print("%s is now editing" % _menu.name)

	_ui_updater.set_edit_mode()

	_toggle_menu_input_handler.toggled.connect(_handle_toggle_menu)

	AppearanceMenuEvents.emit_editing_started()

func uncover() -> void:
	_finish()

func _handle_toggle_menu() -> void:
	_finish()

func _finish() -> void:
	AppearanceMenuEvents.emit_editing_finished()

	transition_state(AppearanceMenu.State.ENABLED)
