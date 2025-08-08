class_name BagMenuStateDisabled
extends BagMenuState

func _enter_tree() -> void:
	print("%s is now disabled" % _menu.name)

	_dimmer.is_dimmed = true

	_disable_animations()

	_index_handler.current_index_changed.connect(_handle_current_index_changed)

	_bag_handler.bag_changed.connect(_handle_bag_changed)

	if _state_data.get_visibility_changed():
		_emit_menu_hidden()

		if _menu_items.size() > 0:
			_index_handler.clamp(_menu_items.get_max_index())

		_menu_items.highlight_current()

func _handle_current_index_changed(index: int) -> void:
	print("%s current index changed %d, stealing control" % [_menu.name, index])

	_menu.steal()

func _handle_bag_changed(item_stacks: Array[ItemStack]) -> void:
	var count_changed := _ui_updater.update_buttons(item_stacks)

	var new_item: Item = null
	if _index_handler.current < _menu_items.size():
		new_item = _menu_items.get_stack().item

	_menu.emit_selected_item_changed(new_item)

	if count_changed:
		print("%s stack count changed" % _menu.name)

func enable() -> void:
	var state_data := BagMenuStateData.build() \
		.with_visibility_changed(true)

	transition_state(BagMenu.State.ENABLED, state_data)
