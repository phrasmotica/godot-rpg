extends Control

@export
var bag: Bag

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
		if item_stack_buttons.size() > current_index:
			item_stack_buttons[current_index].call_deferred("grab_focus")

signal drop_item(stack_id: int)

func _ready():
	if bag:
		bag.added_item.connect(_on_bag_added_item)
		bag.dropped_item.connect(_on_bag_dropped_item)

		bag.drop_item.connect(_on_bag_drop_item)

func update_buttons(item_stacks: Array[ItemStack]):
	var count := len(item_stacks)
	empty_label.visible = count <= 0

	for i in range(item_stacks.size()):
		if item_stack_buttons.size() > i:
			item_stack_buttons[i].show()
			item_stack_buttons[i].stack = item_stacks[i]
		else:
			var new_button: ItemStackButton = item_stack_button_scene.instantiate()

			new_button.index = i
			new_button.stack = item_stacks[i]
			new_button.focused.connect(_on_item_button_focused)

			item_list.add_child(new_button)
			item_stack_buttons.append(new_button)

			new_button.call_deferred("grab_focus")

	# clean up any unused buttons
	for j in range(item_stacks.size(), item_stack_buttons.size()):
		item_stack_buttons[j].hide()

	# ensure the last item stack is focused
	while current_index >= item_stacks.size():
		current_index -= 1

func _on_bag_added_item(new_item: Item, item_stacks: Array[ItemStack]):
	print("Added " + new_item.name + " to bag")

	update_buttons(item_stacks)

func _on_bag_dropped_item(dropped_item: Item, item_stacks: Array[ItemStack]):
	print("Dropped " + dropped_item.name + " from bag")

	update_buttons(item_stacks)

func _on_bag_drop_item():
	if current_index > -1:
		var current_item := item_stack_buttons[current_index]
		drop_item.emit(current_item.stack.id)

func _on_item_button_focused(button: ItemStackButton):
	current_index = button.index

func _on_visibility_changed():
	# TODO: ensure current stack remains focused after hiding and re-showing the bag menu
	if current_index < 0 and len(item_stack_buttons) > 0:
		current_index = 0
