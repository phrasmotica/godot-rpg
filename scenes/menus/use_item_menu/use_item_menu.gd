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

	if bag:
		bag.used_item.connect(_handle_bag_used_item)
		bag.consumed_item.connect(_handle_bag_consumed_item)

	if bag_menu:
		bag_menu.select_stack.connect(bag_menu_handler.handle_select_stack)
		bag_menu.selected_item_changed.connect(_handle_bag_menu_selected_item_changed)

	if map:
		map.player_faced_tile.connect(use_item_menu_behaviour.handle_player_faced_tile)

	bag_menu_handler.selected_item_changed.connect(_handle_selected_item_changed)

	switch_state(State.DISABLED)

func switch_state(state: State, state_data := UseItemMenuStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		list_menu_behaviour,
		use_item_menu_behaviour,
		toggle_menu_input_handler,
		list_menu_input_handler)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "UseItemMenuStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func emit_use() -> void:
	use.emit()

func emit_use_all() -> void:
	use_all.emit()

func emit_drop() -> void:
	drop.emit()

func emit_drop_all() -> void:
	drop_all.emit()

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

func _can_use_item(item: Item) -> bool:
	if not item:
		return false

	var facing_correct_tile := use_item_menu_behaviour.can_use_item(item)
	var can_use := item_consumer.can_use(item) or item_consumer.can_consume(item)

	return facing_correct_tile and can_use

func is_closed() -> bool:
	return _current_state and _current_state.is_closed()
