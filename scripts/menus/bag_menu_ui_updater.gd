@tool
class_name BagMenuUIUpdater extends Node

@export_group("Dependencies")

@export
var menu_items: BagMenuItems

@export
var index_handler: ListIndexHandler

@export
var item_stack_menu_item_scene: PackedScene

@export_group("Controls")

@export
var empty_label: Label

@export
var scroll_container: ScrollContainer

@export
var item_list: VBoxContainer

func _ready() -> void:
	index_handler.current_index_changed.connect(_scroll_to)

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

	if count > 0:
		index_handler.clamp(menu_items.get_max_index())

	menu_items.highlight_current()

	return count_changed

func _scroll_to(index: int) -> void:
	print("Scrolling bag menu to item " + str(index))

	var scroll_y := int(menu_items.get_item_y_pos(index))
	scroll_container.scroll_vertical = scroll_y
