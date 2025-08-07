class_name AppearanceMenuStateDisabled
extends AppearanceMenuState

func _enter_tree() -> void:
	print("%s is now disabled" % _menu.name)

	_dimmer.is_dimmed = true

	_ui_updater.hide_content()

func enable() -> void:
	transition_state(AppearanceMenu.State.ENABLED)

func is_closed() -> bool:
	return true
