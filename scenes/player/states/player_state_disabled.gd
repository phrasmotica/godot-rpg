class_name PlayerStateDisabled
extends PlayerState

func _enter_tree() -> void:
	print("Player is now disabled")

	_ui_manager.menu_closed.connect(_enable)

func _enable() -> void:
	transition_state(Player.State.ENABLED)
