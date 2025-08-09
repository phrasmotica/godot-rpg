class_name AppearanceMenuStateDisabled
extends AppearanceMenuState

func _enter_tree() -> void:
	print("%s is now disabled" % _menu.name)

	_dimmer.is_dimmed = true

	_ui_updater.hide_content()

	if _state_data.get_visibility_changed():
		_menu.emit_menu_hidden()

func enable() -> void:
	var state_data := AppearanceMenuStateData.build() \
		.with_visibility_changed(true)

	transition_state(AppearanceMenu.State.ENABLED, state_data)

func is_closed() -> bool:
	return true
