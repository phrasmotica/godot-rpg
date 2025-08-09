class_name UseItemMenuStateDisabled
extends UseItemMenuState

func _enter_tree() -> void:
	print("%s is now disabled" % _menu.name)

	_menu.hide()
	_menu.emit_menu_hidden()

	_bag_menu.select_stack.connect(_handle_select_stack)

	_map.player_faced_tile.connect(_handle_player_faced_tile)

func _handle_select_stack(stack: ItemStack) -> void:
	print("Showing UseItemMenu for stack ID=" + str(stack.id))

	var state_data := UseItemMenuStateData.build() \
		.with_stack(stack)

	transition_state(UseItemMenu.State.ENABLED, state_data)

func _handle_player_faced_tile(tile: Tile) -> void:
	_use_item_menu_behaviour.handle_player_faced_tile(tile)

func is_closed() -> bool:
	return true
