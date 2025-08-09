class_name BagMenuStateCovered
extends BagMenuState

func _enter_tree() -> void:
	print("%s is now covered" % _menu.name)

	_ui_updater.for_covered()

	_connect_bag_signals()

	_index_handler.current_index_changed.connect(_handle_current_index_changed)

	_use_item_menu.use.connect(_on_use)
	_use_item_menu.drop.connect(_on_drop)
	_use_item_menu.drop_all.connect(_on_drop_all)

	_emit_menu_covered()

func _handle_current_index_changed(index: int) -> void:
	print("%s current index changed %d, stealing control" % [_menu.name, index])

	_menu.steal()

func update_item_stacks(item_stacks: Array[ItemStack]) -> void:
	var count_changed := _ui_updater.update_buttons(item_stacks)

	var new_item: Item = null
	if _index_handler.current < _menu_items.size():
		new_item = _menu_items.get_stack().item

	_menu.emit_selected_item_changed(new_item)

	if count_changed:
		print("%s stack count changed, stealing control" % _menu.name)

		_menu.steal()

func _on_use() -> void:
	var current_stack := _menu_items.get_stack()
	if current_stack:
		_menu.emit_use_item(current_stack.id)

func _on_drop() -> void:
	var current_stack := _menu_items.get_stack()
	if current_stack:
		_menu.emit_drop_item(current_stack.id)

func _on_drop_all() -> void:
	var current_stack := _menu_items.get_stack()
	if current_stack:
		_menu.emit_drop_stack(current_stack.id)

func uncover() -> void:
	var state_data := BagMenuStateData.build() \
		.with_was_uncovered(true)

	transition_state(BagMenu.State.ENABLED, state_data)
