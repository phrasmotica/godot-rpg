class_name BagMenuStateDisabled
extends BagMenuState

func _enter_tree() -> void:
	print("%s is now disabled" % _menu.name)

	_ui_updater.for_disabled()

	_connect_bag_signals()

	_menu_behaviour.current_index_changed.connect(_handle_current_index_changed)

	if _state_data.get_visibility_changed():
		_menu.emit_menu_hidden()

		_menu_behaviour.clamp()

func _handle_current_index_changed(index: int) -> void:
	print("%s current index changed %d, stealing control" % [_menu.name, index])

	_menu.emit_steal_control()

func update_item_stacks(item_stacks: Array[ItemStack]) -> void:
	var count_changed := _ui_updater.update_buttons(item_stacks)

	var new_item := _menu_behaviour.get_item()
	_menu.emit_selected_item_changed(new_item)

	if count_changed:
		print("%s stack count changed" % _menu.name)

func enable() -> void:
	var state_data := BagMenuStateData.build() \
		.with_visibility_changed(true)

	transition_state(BagMenu.State.ENABLED, state_data)
