class_name MenuSetStateDisabled
extends MenuSetState

func _enter_tree() -> void:
	print("MenuSet is now disabled")

	# HIGH: transition to ENABLED when any child menu is uncovered
