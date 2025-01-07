class_name BagMenuUIUpdater extends Node

@export
var menu_items: BagMenuItems

@export
var item_stack_menu_item_scene: PackedScene

@export
var empty_label: Label

@export
var scroll_container: ScrollContainer

@export
var item_list: VBoxContainer

func update_buttons(item_stacks: Array[ItemStack]) -> bool:
	var count := item_stacks.size()
	empty_label.visible = count <= 0

	var count_changed := count != menu_items.size()

	for i in range(item_stacks.size()):
		if menu_items.size() > i:
			menu_items.assign_stack(item_stacks[i], i)
		else:
			var new_button: ItemStackMenuItem = item_stack_menu_item_scene.instantiate()

			new_button.index = i
			new_button.stack = item_stacks[i]

			item_list.add_child(new_button)
			menu_items.add_item(new_button)

	# clean up any unused buttons
	menu_items.trim_to(item_stacks.size())

	return count_changed

func scroll_to_item(index: int) -> void:
	scroll_container.scroll_vertical = int(menu_items.get_item_y_pos(index))
