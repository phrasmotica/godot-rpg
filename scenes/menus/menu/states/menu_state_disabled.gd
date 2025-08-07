class_name MenuStateDisabled
extends MenuState

func _enter_tree() -> void:
	print("%s is now disabled" % _menu.name)

func enable() -> void:
	transition_state(Menu.State.ENABLED)

func is_closed() -> bool:
	return true
