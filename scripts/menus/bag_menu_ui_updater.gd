class_name BagMenuUIUpdater extends Node

@export
var item_stack_menu_item_scene: PackedScene

@export
var empty_label: Label

@export
var scroll_container: ScrollContainer

@export
var item_list: VBoxContainer

func update_buttons(item_stacks: Array[ItemStack], menu_items: Array[ItemStackMenuItem]) -> bool:
	var count := item_stacks.size()
	empty_label.visible = count <= 0

	var count_changed := count != menu_items.size()

	for i in range(item_stacks.size()):
		if menu_items.size() > i:
			menu_items[i].stack = item_stacks[i]
		else:
			var new_button: ItemStackMenuItem = item_stack_menu_item_scene.instantiate()

			new_button.index = i
			new_button.stack = item_stacks[i]

			item_list.add_child(new_button)
			menu_items.append(new_button)

	# clean up any unused buttons
	if menu_items.size() > item_stacks.size():
		for j in range(item_stacks.size(), menu_items.size()):
			menu_items[j].queue_free()

		while menu_items.size() > item_stacks.size():
			menu_items.pop_back()

	return count_changed

func scroll_to_item(index: int, menu_items: Array[ItemStackMenuItem]) -> void:
	var scroll_y := (
		int(menu_items[index].position.y) if index > -1
		else 0
	)

	scroll_container.scroll_vertical = scroll_y
