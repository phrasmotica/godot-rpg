class_name MenuStateEnabled
extends MenuState

func _enter_tree() -> void:
	print("%s is now enabled" % _menu.name)

func disable() -> void:
	transition_state(Menu.State.DISABLED)

func cover() -> void:
	transition_state(Menu.State.COVERED)
