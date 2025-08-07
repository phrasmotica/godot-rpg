class_name AppearanceMenuStateEnabled
extends AppearanceMenuState

func _enter_tree() -> void:
	print("%s is now enabled" % _menu.name)

	_dimmer.is_dimmed = false

	_ui_updater.set_normal_mode()
	_ui_updater.show_content()

	_list_menu_input_handler.select.connect(_handle_select)

func disable() -> void:
	transition_state(AppearanceMenu.State.DISABLED)

func cover() -> void:
	_to_editing()

func _handle_select() -> void:
	var item := _list_menu_behaviour.item()
	if item.disabled:
		return

	_to_editing()

func _to_editing() -> void:
	transition_state(AppearanceMenu.State.EDITING)
