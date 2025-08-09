class_name BagMenuState
extends Node

signal state_transition_requested(new_state: BagMenu.State, state_data: BagMenuStateData)

var _menu: BagMenu = null
var _state_data: BagMenuStateData = null
var _ui_updater: BagMenuUIUpdater = null
var _dimmer: Dimmer = null
var _index_handler: ListIndexHandler = null
var _list_menu_input_handler: ListMenuInputHandler = null
var _menu_behaviour: BagMenuBehaviour = null
var _menu_items: BagMenuItems = null
var _use_item_menu: UseItemMenu = null
var _bag: Bag = null

func setup(
	menu: BagMenu,
	state_data: BagMenuStateData,
	ui_updater: BagMenuUIUpdater,
	dimmer: Dimmer,
	index_handler: ListIndexHandler,
	list_menu_input_handler: ListMenuInputHandler,
	menu_behaviour: BagMenuBehaviour,
	menu_items: BagMenuItems,
	use_item_menu: UseItemMenu,
	bag: Bag,
) -> void:
	_menu = menu
	_state_data = state_data
	_ui_updater = ui_updater
	_dimmer = dimmer
	_index_handler = index_handler
	_list_menu_input_handler = list_menu_input_handler
	_menu_behaviour = menu_behaviour
	_menu_items = menu_items
	_use_item_menu = use_item_menu
	_bag = bag

func transition_state(
	new_state: BagMenu.State,
	state_data := BagMenuStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

func _connect_bag_signals() -> void:
	_bag.added_item.connect(_on_added_item)
	_bag.dropped_item.connect(_on_dropped_item)
	_bag.used_item.connect(_on_used_item)
	_bag.consumed_item.connect(_on_consumed_item)

func _on_added_item(new_item: Item, _altered: bool, item_stacks: Array[ItemStack]) -> void:
	print("Added " + new_item.name + " to bag")
	update_item_stacks(item_stacks)

func _on_dropped_item(dropped_item: Item, item_stacks: Array[ItemStack]) -> void:
	print("Dropped " + dropped_item.name + " from bag")
	update_item_stacks(item_stacks)

func _on_used_item(used_item: Item, item_stacks: Array[ItemStack]) -> void:
	print("Used " + used_item.name + " from bag")
	update_item_stacks(item_stacks)

func _on_consumed_item(consumed_item: Item, item_stacks: Array[ItemStack]) -> void:
	print("Consumed " + consumed_item.name + " from bag")
	update_item_stacks(item_stacks)

func _emit_menu_hidden() -> void:
	_menu.emit_menu_hidden()

func _emit_menu_shown() -> void:
	_menu.emit_menu_shown()

func _emit_menu_covered() -> void:
	_menu.emit_menu_covered()

func _emit_menu_uncovered() -> void:
	_menu.emit_menu_uncovered()

func _disable_animations() -> void:
	_menu_items.disable()

func _enable_animations() -> void:
	_menu_items.enable()

func disable() -> void:
	pass

func enable() -> void:
	pass

func cover() -> void:
	pass

func uncover() -> void:
	pass

func update_item_stacks(_item_stacks: Array[ItemStack]) -> void:
	pass
