class_name UseItemMenuStateCovered
extends UseItemMenuState

func _enter_tree() -> void:
	print("%s is now covered" % _menu.name)

	_menu.show()

	_ui_updater.for_covered()

func uncover() -> void:
	transition_state(UseItemMenu.State.ENABLED)
