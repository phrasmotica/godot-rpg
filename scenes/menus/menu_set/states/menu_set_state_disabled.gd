class_name MenuSetStateDisabled
extends MenuSetState

func _enter_tree() -> void:
	print("MenuSet is now disabled")

	for m in _child_menus:
		m.menu_uncovered.connect(_on_child_menu_uncovered)

func _on_child_menu_uncovered() -> void:
	transition_state(MenuSet.State.ENABLED)
