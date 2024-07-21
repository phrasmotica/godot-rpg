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
var item_stack_menu_item_scene: PackedScene

var item_stack_menu_items: Array[ItemStackMenuItem]

signal add_random_item
signal select_stack(stack: ItemStack)

signal use_item(stack_id: int)

signal drop_item(stack_id: int)
signal drop_stack(stack_id: int)

## Menu overrides

func process_select():
	if current_index < 0 || current_index >= item_stack_menu_items.size():
		return

	var button := item_stack_menu_items[current_index]

	print("Selecting the " + button.stack.item.name)

	select_stack.emit(button.stack)

func next():
	if item_stack_menu_items.size() <= 0:
		return

	current_index = (current_index + 1) % item_stack_menu_items.size()

func previous():
	if item_stack_menu_items.size() <= 0:
		return

	# this weird maths ensures we wrap around to the bottom of the bag
	# if we're currently at the top of it
	current_index = (current_index + item_stack_menu_items.size() - 1) % item_stack_menu_items.size()

func listen_for_inputs():
	if Input.is_action_just_pressed("random_item"):
		add_random_item.emit()

	if Input.is_action_just_pressed("drop_item"):
		drop_current_item()

func highlight_current():
	for button in item_stack_menu_items:
		if button.index == current_index:
			button.select()
		else:
			button.deselect()

func get_max_index():
	return item_stack_menu_items.size() - 1

## Menu signals

func _on_current_index_changed(index: int):
	print("BagMenu current index changed, hiding UseItemMenu")
	use_item_menu.hide()

	print("Scrolling to current item")

	var scroll_y := (
		int(item_stack_menu_items[index].position.y) if current_index > -1
		else 0
	)

	scroll_container.scroll_vertical = scroll_y

## BagMenu-specific

func update_buttons(item_stacks: Array[ItemStack]):
	var count := item_stacks.size()
	empty_label.visible = count <= 0

	var count_changed := count != item_stack_menu_items.size()

	for i in range(item_stacks.size()):
		if item_stack_menu_items.size() > i:
			item_stack_menu_items[i].stack = item_stacks[i]
		else:
			var new_button: ItemStackMenuItem = item_stack_menu_item_scene.instantiate()

			new_button.index = i
			new_button.stack = item_stacks[i]

			item_list.add_child(new_button)
			item_stack_menu_items.append(new_button)

		if current_index < 0:
			current_index = 0

	# clean up any unused buttons
	if item_stack_menu_items.size() > item_stacks.size():
		for j in range(item_stacks.size(), item_stack_menu_items.size()):
			item_stack_menu_items[j].queue_free()

		while item_stack_menu_items.size() > item_stacks.size():
			item_stack_menu_items.pop_back()

	# ensure the last item stack is selected
	while current_index >= item_stacks.size():
		current_index -= 1

	highlight_current()

	if count_changed:
		print("BagMenu stack count changed, hiding UseItemMenu")
		use_item_menu.hide()

func use_current_item():
	if current_index > -1:
		var current_item := item_stack_menu_items[current_index]
		use_item.emit(current_item.stack.id)

func drop_current_item():
	if current_index > -1:
		var current_item := item_stack_menu_items[current_index]
		drop_item.emit(current_item.stack.id)

func drop_current_stack():
	if current_index > -1:
		var current_item := item_stack_menu_items[current_index]
		drop_stack.emit(current_item.stack.id)

func _on_bag_added_item(new_item: Item, item_stacks: Array[ItemStack]):
	print("Added " + new_item.name + " to bag")

	update_buttons(item_stacks)

func _on_bag_dropped_item(dropped_item: Item, item_stacks: Array[ItemStack]):
	print("Dropped " + dropped_item.name + " from bag")

	update_buttons(item_stacks)

func _on_use_item_menu_use():
	use_current_item()

func _on_use_item_menu_drop():
	drop_current_item()

func _on_use_item_menu_drop_all():
	drop_current_stack()
