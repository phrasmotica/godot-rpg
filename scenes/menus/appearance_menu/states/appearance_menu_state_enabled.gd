class_name AppearanceMenuStateEnabled
extends AppearanceMenuState

func _enter_tree() -> void:
	print("%s is now enabled" % _menu.name)

	_dimmer.is_dimmed = false

	_ui_updater.set_normal_mode()
	_ui_updater.show_content()

	_list_menu_input_handler.select.connect(_handle_select)

	if _state_data.get_visibility_changed():
		_emit_menu_shown()

func disable() -> void:
	var state_data := AppearanceMenuStateData.build() \
		.with_visibility_changed(true)

	transition_state(AppearanceMenu.State.DISABLED, state_data)

func _handle_select() -> void:
	var item := _list_menu_behaviour.item()
	if item.disabled:
		return

	transition_state(AppearanceMenu.State.EDITING)
