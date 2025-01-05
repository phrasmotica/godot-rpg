@tool
class_name BagMenu extends ListMenu

# HIGH: cut down on inheritance as much as possible

@export
var item_stack_menu_item_scene: PackedScene

@export
var menu_behaviour: BagMenuBehaviour

@onready
var list_menu_input_handler: ListMenuInputHandler = %ListMenuInputHandler

@onready
var dimmer: Dimmer = %Dimmer

@onready
var empty_label: Label = %EmptyLabel

@onready
var scroll_container: ScrollContainer = %ScrollContainer

@onready
var item_list: VBoxContainer = %ItemList

var item_stack_menu_items: Array[ItemStackMenuItem]

signal select_stack(stack: ItemStack)

signal use_item(stack_id: int)

signal drop_item(stack_id: int)
signal drop_stack(stack_id: int)

signal selected_item_changed(item: Item)

func _ready():
	if Engine.is_editor_hint():
		return

	list_menu_input_handler.next.connect(_handle_next)
	list_menu_input_handler.previous.connect(_handle_previous)
	list_menu_input_handler.select.connect(_handle_select)

func _handle_next() -> void:
	if item_stack_menu_items.size() <= 0:
		return

	current_index = menu_behaviour.next(item_stack_menu_items, current_index)

func _handle_previous():
	if item_stack_menu_items.size() <= 0:
		return

	current_index = menu_behaviour.previous(item_stack_menu_items, current_index)

func _handle_select():
	if current_index < 0 || current_index >= item_stack_menu_items.size():
		return

	var stack := menu_behaviour.get_stack(item_stack_menu_items, current_index)
	if not stack:
		return

	print("Selecting the " + stack.item.name)

	select_stack.emit(stack)

## Menu overrides

func highlight_current():
	for button in item_stack_menu_items:
		if button.index == current_index:
			button.select()
		else:
			button.deselect()

func get_max_index():
	return item_stack_menu_items.size() - 1

func disable_menu() -> void:
	_dim_menu()

func enable_menu() -> void:
	_undim_menu()

func cover_menu() -> void:
	super.cover_menu()

	_dim_menu()

func uncover_menu() -> void:
	super.uncover_menu()

	_undim_menu()

func _dim_menu() -> void:
	dimmer.is_dimmed = true
	menu_state_handler.disable()

	disable_animations()

func _undim_menu() -> void:
	dimmer.is_dimmed = false
	menu_state_handler.enable()

	enable_animations()

func disable_animations():
	for x in item_stack_menu_items:
		x.disable_item()

func enable_animations():
	for x in item_stack_menu_items:
		x.enable_item()

## Menu signals

func _on_current_index_changed(index: int):
	print("BagMenu current index changed " + str(index))

	if dimmer.is_dimmed and is_visible_in_tree():
		print("BagMenu current index changed, stealing control")
		steal()

	print("BagMenu scrolling to item " + str(index))

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

	# clean up any unused buttons
	if item_stack_menu_items.size() > item_stacks.size():
		for j in range(item_stacks.size(), item_stack_menu_items.size()):
			item_stack_menu_items[j].queue_free()

		while item_stack_menu_items.size() > item_stacks.size():
			item_stack_menu_items.pop_back()

	if item_stacks.size() > 0:
		current_index = clampi(current_index, 0, item_stacks.size() - 1)

	highlight_current()

	var new_item: Item = null
	if current_index < item_stack_menu_items.size():
		new_item = item_stack_menu_items[current_index].stack.item

	selected_item_changed.emit(new_item)

	if is_visible_in_tree() and count_changed:
		print("BagMenu stack count changed, stealing control")

		steal()

func use_current_item() -> void:
	var current_stack := _get_current_stack()
	if current_stack:
		use_item.emit(current_stack.id)

func drop_current_item():
	var current_stack := _get_current_stack()
	if current_stack:
		drop_item.emit(current_stack.id)

func drop_current_stack():
	var current_stack := _get_current_stack()
	if current_stack:
		drop_stack.emit(current_stack.id)

func _get_current_stack() -> ItemStack:
	if current_index > -1:
		return item_stack_menu_items[current_index].stack

	return null

func _on_bag_added_item(new_item: Item, _altered: bool, item_stacks: Array[ItemStack]):
	print("Added " + new_item.name + " to bag")

	update_buttons(item_stacks)

func _on_bag_dropped_item(dropped_item: Item, item_stacks: Array[ItemStack]):
	print("Dropped " + dropped_item.name + " from bag")

	update_buttons(item_stacks)

func _on_bag_used_item(used_item: Item, item_stacks: Array[ItemStack]):
	print("Used " + used_item.name + " from bag")

	update_buttons(item_stacks)

func _on_bag_consumed_item(consumed_item:Item, item_stacks:Array[ItemStack]):
	print("Consumed " + consumed_item.name + " from bag")

	update_buttons(item_stacks)

func _on_use_item_menu_use():
	use_current_item()

func _on_use_item_menu_drop():
	drop_current_item()

func _on_use_item_menu_drop_all():
	drop_current_stack()
