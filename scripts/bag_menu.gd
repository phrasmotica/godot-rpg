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
var current_item: ItemStackButton

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
			item_stack_buttons[i].stack = item_stacks[i]
		else:
			var new_button: ItemStackButton = item_stack_button_scene.instantiate()

			new_button.stack = item_stacks[i]
			new_button.focused.connect(_on_item_button_focused)

			item_list.add_child(new_button)
			item_stack_buttons.append(new_button)

			new_button.call_deferred("grab_focus")

	# TODO: account for there being extra unused item stack buttons

func _on_bag_added_item(new_item: Item, item_stacks: Array[ItemStack]):
	print("Added " + new_item.name + " to bag")

	update_buttons(item_stacks)

func _on_bag_dropped_item(dropped_item: Item, item_stacks: Array[ItemStack]):
	print("Dropped " + dropped_item.name + " from bag")

	update_buttons(item_stacks)

func _on_bag_drop_item():
	if current_item:
		drop_item.emit(current_item.stack.id)

func _on_item_button_focused(button: ItemStackButton):
	current_item = button

func _on_visibility_changed():
	if not current_item and len(item_stack_buttons) > 0:
		current_item = item_stack_buttons[0]

	if current_item:
		current_item.grab_focus()
