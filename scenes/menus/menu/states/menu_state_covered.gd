class_name MenuStateCovered
extends MenuState

func _enter_tree() -> void:
	print("%s is now covered" % _menu.name)

func uncover() -> void:
	transition_state(Menu.State.ENABLED)

func is_covered() -> bool:
	return true
