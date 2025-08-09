class_name UseItemMenuStateDisabled
extends UseItemMenuState

func _enter_tree() -> void:
	print("%s is now disabled" % _menu.name)

	_menu.hide()
	_menu.bag_menu_handler.show_menu.connect(_handle_show_menu)

	_emit_menu_hidden()

func _handle_show_menu(stack: ItemStack) -> void:
	print("Showing UseItemMenu for stack ID=" + str(stack.id))

	var state_data := UseItemMenuStateData.build() \
		.with_stack(stack)

	transition_state(UseItemMenu.State.ENABLED, state_data)

func is_closed() -> bool:
	return true
