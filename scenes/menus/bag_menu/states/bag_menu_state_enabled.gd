class_name BagMenuStateEnabled
extends BagMenuState

func _enter_tree() -> void:
	print("%s is now enabled" % _menu.name)

	_ui_updater.for_enabled()

	_connect_bag_signals()

	_menu_behaviour.current_index_changed.connect(_handle_current_index_changed)

	_list_menu_input_handler.select.connect(_handle_select)
	_list_menu_input_handler.next.connect(_handle_next)
	_list_menu_input_handler.previous.connect(_handle_previous)

	if _state_data.get_visibility_changed():
		_emit_menu_shown()

		_menu_behaviour.clamp()

	if _state_data.get_was_uncovered():
		_emit_menu_uncovered()

func disable() -> void:
	var state_data := BagMenuStateData.build() \
		.with_visibility_changed(true)

	transition_state(BagMenu.State.DISABLED, state_data)

func cover() -> void:
	transition_state(BagMenu.State.COVERED)

func _handle_current_index_changed(index: int) -> void:
	print("%s current index changed %d" % [_menu.name, index])

func update_item_stacks(item_stacks: Array[ItemStack]) -> void:
	var count_changed := _ui_updater.update_buttons(item_stacks)

	var new_item := _menu_behaviour.get_item()
	_menu.emit_selected_item_changed(new_item)

	if count_changed:
		print("%s stack count changed" % _menu.name)

func _handle_select() -> void:
	var stack := _menu_behaviour.get_item_stack()
	if not stack:
		return

	print("Selecting the " + stack.item.name)

	_menu.emit_select_stack(stack)

func _handle_next() -> void:
	print("%s moving to next item" % _menu.name)

	_menu_behaviour.next()

func _handle_previous() -> void:
	print("%s moving to previous item" % _menu.name)

	_menu_behaviour.previous()
