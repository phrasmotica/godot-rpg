@tool
class_name BagMenu extends Menu

enum State { DISABLED, ENABLED, COVERED }

# HIGH: cut down on inheritance as much as possible

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

signal select_stack(stack: ItemStack)

signal use_item(stack_id: int)

signal drop_item(stack_id: int)
signal drop_stack(stack_id: int)

signal selected_item_changed(item: Item)

var _state_factory := BagMenuStateFactory.new()
var _current_state: BagMenuState = null

func _ready() -> void:
	if menu_items.size() > 0:
		index_handler.clamp(menu_items.get_max_index())

	if Engine.is_editor_hint():
		return

	switch_state(State.DISABLED)

	bag_handler.bag_changed.connect(_handle_bag_changed)

	if bag:
		bag.added_item.connect(bag_handler.handle_bag_added_item)
		bag.dropped_item.connect(bag_handler.handle_bag_dropped_item)
		bag.used_item.connect(bag_handler.handle_bag_used_item)
		bag.consumed_item.connect(bag_handler.handle_bag_consumed_item)

	if use_item_menu:
		use_item_menu.use.connect(use_current_item)
		use_item_menu.drop.connect(drop_current_item)
		use_item_menu.drop_all.connect(drop_current_stack)

func switch_state(state: State, state_data := BagMenuStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		ui_updater,
		dimmer,
		index_handler,
		list_menu_input_handler,
		menu_behaviour,
		menu_items)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "BagMenuStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

## Menu overrides

func disable_menu() -> void:
	if _current_state:
		_current_state.disable()

func enable_menu() -> void:
	if _current_state:
		_current_state.enable()

func cover_menu() -> void:
	if _current_state:
		_current_state.cover()

func uncover_menu() -> void:
	if _current_state:
		_current_state.uncover()

## BagMenu-specific

func emit_select_stack(stack: ItemStack) -> void:
	select_stack.emit(stack)

# TODO: make this state-specific, so that we can remove the dependency on menu_state_handler
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
