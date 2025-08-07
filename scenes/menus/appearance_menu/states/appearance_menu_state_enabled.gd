class_name AppearanceMenuStateEnabled
extends AppearanceMenuState

func _enter_tree() -> void:
	print("%s is now enabled" % _menu.name)

	_dimmer.is_dimmed = false

	_ui_updater.show_content()

	_toggle_menu_input_handler.toggled.connect(_handle_toggle_menu)

	_list_menu_input_handler.select.connect(_handle_select)

func disable() -> void:
	transition_state(AppearanceMenu.State.DISABLED)

func cover() -> void:
	transition_state(AppearanceMenu.State.COVERED)

func _handle_toggle_menu() -> void:
	_menu._handle_cancel()

func _handle_select() -> void:
	_menu._handle_select()
