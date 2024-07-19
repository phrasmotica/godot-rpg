@tool
extends Menu

@export
var use_item_menu: Menu

@export
var scroll_container: ScrollContainer

@export
var item_list: VBoxContainer

@export
var empty_label: Label

@export
var item_stack_button_scene: PackedScene

var item_stack_buttons: Array[ItemStackButton]

signal add_random_item
signal select_stack(stack: ItemStack)

signal drop_item(stack_id: int)
signal drop_stack(stack_id: int)

signal bag_closed

## Menu overrides

func process_select():
	if current_index < 0 || current_index >= item_stack_buttons.size():
		return

	var button := item_stack_buttons[current_index]

	print("Selecting the " + button.stack.item.name)

	select_stack.emit(button.stack)

func next():
	if item_stack_buttons.size() <= 0:
		return

	current_index = (current_index + 1) % item_stack_buttons.size()

func previous():
	if item_stack_buttons.size() <= 0:
		return

	# this weird maths ensures we wrap around to the bottom of the bag
	# if we're currently at the top of it
	current_index = (current_index + item_stack_buttons.size() - 1) % item_stack_buttons.size()

func cancel_menu():
	hide()

	bag_closed.emit()

	print("Hiding BagMenu")

func listen_for_inputs():
	if Input.is_action_just_pressed("random_item"):
		add_random_item.emit()

	if Input.is_action_just_pressed("drop_item"):
		drop_current_item()

func highlight_current():
	for button in item_stack_buttons:
		if button.index == current_index:
			button.select()
		else:
			button.deselect()

func get_max_index():
	return item_stack_buttons.size() - 1

## Menu signals

func _on_current_index_changed(index: int):
	print("BagMenu current index changed, hiding UseItemMenu")
	use_item_menu.hide()

	print("Scrolling to current item")

	# HIGH: compute this 34 from the child item stack buttons
	scroll_container.scroll_vertical = index * 34

## BagMenu-specific

func update_buttons(item_stacks: Array[ItemStack]):
	var count := item_stacks.size()
	empty_label.visible = count <= 0

	var count_changed := count != item_stack_buttons.size()

	for i in range(item_stacks.size()):
		if item_stack_buttons.size() > i:
			item_stack_buttons[i].stack = item_stacks[i]
		else:
			var new_button: ItemStackButton = item_stack_button_scene.instantiate()

			new_button.index = i
			new_button.stack = item_stacks[i]

			item_list.add_child(new_button)
			item_stack_buttons.append(new_button)

		if current_index < 0:
			current_index = 0

	# clean up any unused buttons
	if item_stack_buttons.size() > item_stacks.size():
		for j in range(item_stacks.size(), item_stack_buttons.size()):
			item_stack_buttons[j].queue_free()

		while item_stack_buttons.size() > item_stacks.size():
			item_stack_buttons.pop_back()

	# ensure the last item stack is selected
	while current_index >= item_stacks.size():
		current_index -= 1

	highlight_current()

	if count_changed:
		print("BagMenu stack count changed, hiding UseItemMenu")
		use_item_menu.hide()

func drop_current_item():
	if current_index > -1:
		var current_item := item_stack_buttons[current_index]
		drop_item.emit(current_item.stack.id)

func drop_current_stack():
	if current_index > -1:
		var current_item := item_stack_buttons[current_index]
		drop_stack.emit(current_item.stack.id)

func _on_bag_added_item(new_item: Item, item_stacks: Array[ItemStack]):
	print("Added " + new_item.name + " to bag")

	update_buttons(item_stacks)

func _on_bag_dropped_item(dropped_item: Item, item_stacks: Array[ItemStack]):
	print("Dropped " + dropped_item.name + " from bag")

	update_buttons(item_stacks)

func _on_use_item_menu_visibility_changed():
	if use_item_menu.visible:
		dim()
		set_process(false)
	else:
		undim()
		set_process(true)

func dim():
	modulate = Color.GRAY

func undim():
	modulate = Color.WHITE

func _on_use_item_menu_drop():
	drop_current_item()

func _on_use_item_menu_drop_all():
	drop_current_stack()
