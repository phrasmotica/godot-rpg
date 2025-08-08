class_name BagMenuStateDisabled
extends BagMenuState

func _enter_tree() -> void:
	print("%s is now disabled" % _menu.name)

	_dimmer.is_dimmed = true

	_disable_animations()

	_index_handler.current_index_changed.connect(_handle_current_index_changed)

	if _state_data.get_visibility_changed():
		_emit_menu_hidden()

		if _menu_items.size() > 0:
			_index_handler.clamp(_menu_items.get_max_index())

		_menu_items.highlight_current()

func _handle_current_index_changed(index: int) -> void:
	print("BagMenu current index changed %d, stealing control" % index)

	_menu.steal()

func enable() -> void:
	var state_data := BagMenuStateData.build() \
		.with_visibility_changed(true)

	transition_state(BagMenu.State.ENABLED, state_data)
