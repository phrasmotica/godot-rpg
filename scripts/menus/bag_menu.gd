@tool
class_name BagMenu extends Menu

# HIGH: cut down on inheritance as much as possible

@export
var bag: Bag

@export
var use_item_menu: UseItemMenu

@onready
var menu_behaviour: BagMenuBehaviour = %BagMenuBehaviour

@onready
var index_handler: ListIndexHandler = %ListIndexHandler

@onready
var list_menu_input_handler: ListMenuInputHandler = %ListMenuInputHandler

@onready
var dimmer: Dimmer = %Dimmer

@onready
var ui_updater: BagMenuUIUpdater = %UIUpdater

var item_stack_menu_items: Array[ItemStackMenuItem]

signal select_stack(stack: ItemStack)

signal use_item(stack_id: int)

signal drop_item(stack_id: int)
signal drop_stack(stack_id: int)

signal selected_item_changed(item: Item)

func _ready() -> void:
	if item_stack_menu_items.size() > 0:
		index_handler.clamp(_get_max_index())

	if Engine.is_editor_hint():
		return

	index_handler.current_index_changed.connect(_handle_current_index_changed)
	visibility_changed.connect(_handle_visibility_changed)

	if bag:
		bag.added_item.connect(_handle_bag_added_item)
		bag.dropped_item.connect(_handle_bag_dropped_item)
		bag.used_item.connect(_handle_bag_used_item)
		bag.consumed_item.connect(_handle_bag_consumed_item)

	if use_item_menu:
		use_item_menu.use.connect(use_current_item)
		use_item_menu.drop.connect(drop_current_item)
		use_item_menu.drop_all.connect(drop_current_stack)

	list_menu_input_handler.next.connect(_handle_next)
	list_menu_input_handler.previous.connect(_handle_previous)
	list_menu_input_handler.select.connect(_handle_select)

func _handle_next() -> void:
	if item_stack_menu_items.size() <= 0:
		return

	menu_behaviour.next(item_stack_menu_items)

func _handle_previous() -> void:
	if item_stack_menu_items.size() <= 0:
		return

	menu_behaviour.previous(item_stack_menu_items)

func _handle_current_index_changed(index: int) -> void:
	print("BagMenu current index changed " + str(index))

	if dimmer.is_dimmed and is_visible_in_tree():
		print("BagMenu current index changed, stealing control")
		steal()

	print("BagMenu scrolling to item " + str(index))

	ui_updater.scroll_to_item(index, item_stack_menu_items)

	_highlight_current()

func _handle_select() -> void:
	if index_handler.current < 0 || index_handler.current > _get_max_index():
		return

	var stack := menu_behaviour.get_stack(item_stack_menu_items)
	if not stack:
		return

	print("Selecting the " + stack.item.name)

	select_stack.emit(stack)

func _highlight_current() -> void:
	for button in item_stack_menu_items:
		if button.index == index_handler.current:
			button.select()
		else:
			button.deselect()

## Menu overrides

func after_visibility_changed() -> void:
	if item_stack_menu_items.size() > 0:
		index_handler.clamp(_get_max_index())

	_highlight_current()

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

func disable_animations() -> void:
	for x in item_stack_menu_items:
		x.disable_item()

func enable_animations() -> void:
	for x in item_stack_menu_items:
		x.enable_item()

## BagMenu-specific

func update_buttons(item_stacks: Array[ItemStack]) -> void:
	var count_changed := ui_updater.update_buttons(item_stacks, item_stack_menu_items)

	if item_stacks.size() > 0:
		index_handler.clamp(_get_max_index())

	_highlight_current()

	var new_item: Item = null
	if index_handler.current < item_stack_menu_items.size():
		new_item = item_stack_menu_items[index_handler.current].stack.item

	selected_item_changed.emit(new_item)

	if is_visible_in_tree() and count_changed:
		print("BagMenu stack count changed, stealing control")

		steal()

func use_current_item() -> void:
	var current_stack := _get_current_stack()
	if current_stack:
		use_item.emit(current_stack.id)

func drop_current_item() -> void:
	var current_stack := _get_current_stack()
	if current_stack:
		drop_item.emit(current_stack.id)

func drop_current_stack() -> void:
	var current_stack := _get_current_stack()
	if current_stack:
		drop_stack.emit(current_stack.id)

func _get_current_stack() -> ItemStack:
	if index_handler.current > -1:
		return item_stack_menu_items[index_handler.current].stack

	return null

func _get_max_index() -> int:
	return item_stack_menu_items.size() - 1

func _handle_bag_added_item(new_item: Item, _altered: bool, item_stacks: Array[ItemStack]) -> void:
	print("Added " + new_item.name + " to bag")

	update_buttons(item_stacks)

func _handle_bag_dropped_item(dropped_item: Item, item_stacks: Array[ItemStack]) -> void:
	print("Dropped " + dropped_item.name + " from bag")

	update_buttons(item_stacks)

func _handle_bag_used_item(used_item: Item, item_stacks: Array[ItemStack]) -> void:
	print("Used " + used_item.name + " from bag")

	update_buttons(item_stacks)

func _handle_bag_consumed_item(consumed_item:Item, item_stacks:Array[ItemStack]) -> void:
	print("Consumed " + consumed_item.name + " from bag")

	update_buttons(item_stacks)
