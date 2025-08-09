@tool
class_name UseItemMenu extends Menu

enum State { DISABLED, ENABLED }

@export_group("Dependencies")

@export
var toggle_menu_input_handler: ToggleMenuInputHandler

@export
var bag: Bag

@export
var bag_menu: BagMenu

@export
var item_consumer: ItemConsumer

@export
var map: Map

@onready
var list_menu_behaviour: ListMenu = %ListMenuBehaviour

@onready
var use_item_menu_behaviour: UseItemMenuBehaviour = %UseItemMenuBehaviour

@onready
var bag_menu_handler: BagMenuHandler = %BagMenuHandler

@onready
var list_menu_input_handler: ListMenuInputHandler = %ListMenuInputHandler

@onready
var ui_updater: UseItemMenuUIUpdater = %UIUpdater

var _state_factory := UseItemMenuStateFactory.new()
var _current_state: UseItemMenuState = null

signal use
signal use_all
signal drop
signal drop_all

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	cancel.connect(_handle_cancel)
	visibility_changed.connect(_handle_visibility_changed)

	if bag:
		bag.used_item.connect(_handle_bag_used_item)
		bag.consumed_item.connect(_handle_bag_consumed_item)

	if bag_menu:
		bag_menu.select_stack.connect(bag_menu_handler.handle_select_stack)
		bag_menu.selected_item_changed.connect(_handle_bag_menu_selected_item_changed)

	if map:
		map.player_faced_tile.connect(use_item_menu_behaviour.handle_player_faced_tile)

	use_item_menu_behaviour.use.connect(use.emit)
	use_item_menu_behaviour.use_all.connect(use_all.emit)
	use_item_menu_behaviour.drop.connect(drop.emit)
	use_item_menu_behaviour.drop_all.connect(drop_all.emit)

	list_menu_behaviour.select_index.connect(use_item_menu_behaviour.handle_action)

	bag_menu_handler.show_menu.connect(_handle_show_menu)
	bag_menu_handler.selected_item_changed.connect(_handle_selected_item_changed)

	toggle_menu_input_handler.toggled.connect(_handle_toggle_menu)

	list_menu_input_handler.next.connect(_handle_next)
	list_menu_input_handler.previous.connect(_handle_previous)
	list_menu_input_handler.select.connect(_handle_select)

	disable_menu()

	switch_state(State.DISABLED)

func switch_state(state: State, state_data := UseItemMenuStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "UseItemMenuStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func _handle_toggle_menu() -> void:
	if menu_state_handler.can_listen():
		cancel_menu()

func _handle_next() -> void:
	list_menu_behaviour.next()
	list_menu_behaviour.next_if_disabled()

func _handle_previous() -> void:
	list_menu_behaviour.previous()
	list_menu_behaviour.previous_if_disabled()

func _handle_select_index(index: int) -> void:
	var item := list_menu_behaviour.items[index] as UseItemMenuItem
	use_item_menu_behaviour.handle_action(item.action)

func _handle_select() -> void:
	var item := list_menu_behaviour.item()
	if item.disabled:
		return

	if item.is_cancel:
		cancel_menu()
	else:
		list_menu_behaviour.select_current()

func _handle_bag_menu_selected_item_changed(item: Item) -> void:
	bag_menu_handler.select_item(item)

func _handle_bag_used_item(used_item: Item, _item_stacks: Array[ItemStack]) -> void:
	bag_menu_handler.select_item(used_item)

func _handle_bag_consumed_item(consumed_item: Item, _item_stacks:Array[ItemStack]) -> void:
	bag_menu_handler.select_item(consumed_item)

func _handle_selected_item_changed(item: Item) -> void:
	_update_for(item)

func _update_for(item: Item) -> void:
	var can_use := _can_use_item(item)

	ui_updater.update_for(item, can_use)

	list_menu_behaviour.next_if_disabled()

func _handle_show_menu(stack: ItemStack) -> void:
	print("Showing UseItemMenu for stack ID=" + str(stack.id))

	bag_menu_handler.select_item(stack.item)

	enable_menu()
	show()

func _handle_cancel() -> void:
	print("Hiding UseItemMenu")

	disable_menu()
	hide()

func _can_use_item(item: Item) -> bool:
	if not item:
		return false

	var facing_correct_tile := use_item_menu_behaviour.can_use_item(item)
	var can_use := item_consumer.can_use(item) or item_consumer.can_consume(item)

	return facing_correct_tile and can_use

func is_closed() -> bool:
	return not is_visible_in_tree()
