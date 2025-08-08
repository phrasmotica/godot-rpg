class_name BagMenuStateCovered
extends BagMenuState

func _enter_tree() -> void:
	print("%s is now covered" % _menu.name)

	_dimmer.is_dimmed = true

	_disable_animations()

	_index_handler.current_index_changed.connect(_handle_current_index_changed)

	_emit_menu_covered()

func _handle_current_index_changed(index: int) -> void:
	print("BagMenu current index changed %d, stealing control" % index)

	_menu.steal()

func uncover() -> void:
	var state_data := BagMenuStateData.build() \
		.with_was_uncovered(true)

	transition_state(BagMenu.State.ENABLED, state_data)
