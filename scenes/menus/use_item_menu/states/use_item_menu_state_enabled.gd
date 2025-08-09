class_name UseItemMenuStateEnabled
extends UseItemMenuState

func _enter_tree() -> void:
	print("%s is now enabled" % _menu.name)

	_menu.show()

	_use_item_menu_behaviour.use.connect(_emit_use)
	_use_item_menu_behaviour.use_all.connect(_emit_use_all)
	_use_item_menu_behaviour.drop.connect(_emit_drop)
	_use_item_menu_behaviour.drop_all.connect(_emit_drop_all)

	_toggle_menu_input_handler.toggled.connect(_handle_toggle_menu)

	_list_menu_input_handler.next.connect(_handle_next)
	_list_menu_input_handler.previous.connect(_handle_previous)
	_list_menu_input_handler.select.connect(_handle_select)

	_emit_menu_shown()

func _emit_use() -> void:
	_menu.emit_use()

func _emit_use_all() -> void:
	_menu.emit_use_all()

func _emit_drop() -> void:
	_menu.emit_drop()

func _emit_drop_all() -> void:
	_menu.emit_drop_all()

func _handle_toggle_menu() -> void:
	print("Hiding %s" % _menu.name)

	transition_state(UseItemMenu.State.DISABLED)

func _handle_next() -> void:
	_list_menu_behaviour.next()
	_list_menu_behaviour.next_if_disabled()

func _handle_previous() -> void:
	_list_menu_behaviour.previous()
	_list_menu_behaviour.previous_if_disabled()

func _handle_select() -> void:
	var item := _list_menu_behaviour.item()
	if item.disabled:
		return

	if item.is_cancel:
		print("Cancelling %s" % _menu.name)

		transition_state(UseItemMenu.State.DISABLED)
	else:
		var action := _list_menu_behaviour.get_current_index()
		_use_item_menu_behaviour.handle_action(action)
