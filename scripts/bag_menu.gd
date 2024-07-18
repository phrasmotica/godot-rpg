extends Control

@export
var bag: Bag

@export
var use_item_menu: Menu

@export
var item_list: VBoxContainer

@export
var empty_label: Label

@export
var item_stack_button_scene: PackedScene

var item_stack_buttons: Array[ItemStackButton]

var current_index := -1:
	set(value):
		current_index = value
		select_current()

signal add_random_item
signal select(stack_id: int)

signal drop_item(stack_id: int)
signal drop_stack(stack_id: int)

signal bag_closed

func _ready():
	if bag:
		bag.added_item.connect(_on_bag_added_item)
		bag.dropped_item.connect(_on_bag_dropped_item)

	set_process(visible)

func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
		select_item()

	if Input.is_action_just_pressed("ui_down"):
		next_item_stack()

	if Input.is_action_just_pressed("ui_up"):
		previous_item_stack()

	if Input.is_action_just_pressed("ui_cancel"):
		hide()

		bag_closed.emit()

	if Input.is_action_just_pressed("random_item"):
		add_random_item.emit()

	if Input.is_action_just_pressed("drop_item"):
		drop_current_item()

func select_item():
	if current_index < 0 || current_index >= item_stack_buttons.size():
		return

	var button := item_stack_buttons[current_index]

	print("Selecting the " + button.stack.item.name)

	select.emit(button.stack.id)

func next_item_stack():
	if item_stack_buttons.size() <= 0:
		return

	current_index = (current_index + 1) % item_stack_buttons.size()

func previous_item_stack():
	if item_stack_buttons.size() <= 0:
		return

	# this weird maths ensures we wrap around to the bottom of the bag
	# if we're currently at the top of it
	current_index = (current_index + item_stack_buttons.size() - 1) % item_stack_buttons.size()

func update_buttons(item_stacks: Array[ItemStack]):
	var count := len(item_stacks)
	empty_label.visible = count <= 0

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

	select_current()

func _on_bag_added_item(new_item: Item, item_stacks: Array[ItemStack]):
	print("Added " + new_item.name + " to bag")

	update_buttons(item_stacks)

func _on_bag_dropped_item(dropped_item: Item, item_stacks: Array[ItemStack]):
	print("Dropped " + dropped_item.name + " from bag")

	update_buttons(item_stacks)

func drop_current_item():
	if current_index > -1:
		var current_item := item_stack_buttons[current_index]
		drop_item.emit(current_item.stack.id)

func drop_current_stack():
	if current_index > -1:
		var current_item := item_stack_buttons[current_index]
		drop_stack.emit(current_item.stack.id)

func _on_visibility_changed():
	select_current()

	set_process(visible)

func select_current():
	for button in item_stack_buttons:
		if button.index == current_index:
			button.select()
		else:
			button.deselect()

func _on_use_item_menu_visibility_changed():
	set_process(not use_item_menu.visible)

func _on_use_item_menu_drop():
	drop_current_item()

func _on_use_item_menu_drop_all():
	drop_current_stack()
