@tool
class_name BagMenu extends Menu

# HIGH: cut down on inheritance as much as possible

@export_group("Behaviour")

@export
var close_on_select := false:
	set(value):
		close_on_select = value

@export_group("Dependencies")

@export
var bag: Bag

@export
var use_item_menu: UseItemMenu

@onready
var menu_behaviour: BagMenuBehaviour = %BagMenuBehaviour

@onready
var menu_items: BagMenuItems = %BagMenuItems

@onready
var index_handler: ListIndexHandler = %ListIndexHandler

@onready
var bag_handler: BagHandler = %BagHandler

@onready
var list_menu_input_handler: ListMenuInputHandler = %ListMenuInputHandler

@onready
var dimmer: Dimmer = %Dimmer

@onready
var ui_updater: BagMenuUIUpdater = %UIUpdater

signal select_stack(stack: ItemStack, should_close: bool)

signal use_item(stack_id: int)

signal drop_item(stack_id: int)
signal drop_stack(stack_id: int)

signal selected_item_changed(item: Item)

func _ready() -> void:
	if menu_items.size() > 0:
		index_handler.clamp(menu_items.get_max_index())

	if Engine.is_editor_hint():
		return

	index_handler.current_index_changed.connect(_handle_current_index_changed)
	visibility_changed.connect(_handle_visibility_changed)

	bag_handler.bag_changed.connect(_handle_bag_changed)

	list_menu_input_handler.next.connect(menu_behaviour.next)
	list_menu_input_handler.previous.connect(menu_behaviour.previous)
	list_menu_input_handler.select.connect(_handle_select)

	if bag:
		bag.added_item.connect(bag_handler.handle_bag_added_item)
		bag.dropped_item.connect(bag_handler.handle_bag_dropped_item)
		bag.used_item.connect(bag_handler.handle_bag_used_item)
		bag.consumed_item.connect(bag_handler.handle_bag_consumed_item)

	if use_item_menu:
		use_item_menu.use.connect(use_current_item)
		use_item_menu.drop.connect(drop_current_item)
		use_item_menu.drop_all.connect(drop_current_stack)

func _handle_current_index_changed(index: int) -> void:
	print("BagMenu current index changed " + str(index))

	if not menu_state_handler.can_listen():
		print("BagMenu current index changed, stealing control")
		steal()

func _handle_select() -> void:
	var stack := menu_items.get_stack()
	if not stack:
		return

	print("Selecting the " + stack.item.name)

	select_stack.emit(stack, close_on_select)

## Menu overrides

func after_visibility_changed() -> void:
	if menu_items.size() > 0:
		index_handler.clamp(menu_items.get_max_index())

	menu_items.highlight_current()

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
	menu_items.disable()

func enable_animations() -> void:
	menu_items.enable()

## BagMenu-specific

func _handle_bag_changed(item_stacks: Array[ItemStack]) -> void:
	var count_changed := ui_updater.update_buttons(item_stacks)

	var new_item: Item = null
	if index_handler.current < menu_items.size():
		new_item = menu_items.get_stack().item

	selected_item_changed.emit(new_item)

	if count_changed and not menu_state_handler.can_listen():
		print("BagMenu stack count changed, stealing control")

		steal()

func use_current_item() -> void:
	var current_stack := menu_items.get_stack()
	if current_stack:
		use_item.emit(current_stack.id)

func drop_current_item() -> void:
	var current_stack := menu_items.get_stack()
	if current_stack:
		drop_item.emit(current_stack.id)

func drop_current_stack() -> void:
	var current_stack := menu_items.get_stack()
	if current_stack:
		drop_stack.emit(current_stack.id)
