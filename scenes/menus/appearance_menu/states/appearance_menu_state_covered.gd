class_name AppearanceMenuStateCovered
extends AppearanceMenuState

func _enter_tree() -> void:
	print("%s is now covered" % _menu.name)

	_dimmer.is_dimmed = true

func uncover() -> void:
	_dimmer.is_dimmed = false

	transition_state(AppearanceMenu.State.ENABLED)

func is_covered() -> bool:
	return true
