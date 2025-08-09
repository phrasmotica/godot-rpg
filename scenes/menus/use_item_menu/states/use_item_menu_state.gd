class_name UseItemMenuState
extends Node

signal state_transition_requested(new_state: UseItemMenu.State, state_data: UseItemMenuStateData)

var _menu: UseItemMenu = null
var _state_data: UseItemMenuStateData = null
var _list_menu_behaviour: ListMenu = null
var _use_item_menu_behaviour: UseItemMenuBehaviour = null
var _toggle_menu_input_handler: ToggleMenuInputHandler = null
var _list_menu_input_handler: ListMenuInputHandler = null
var _bag_menu_handler: BagMenuHandler = null
var _ui_updater: UseItemMenuUIUpdater = null
var _item_consumer: ItemConsumer = null

func setup(
	menu: UseItemMenu,
	state_data: UseItemMenuStateData,
	list_menu_behaviour: ListMenu,
	use_item_menu_behaviour: UseItemMenuBehaviour,
	toggle_menu_input_handler: ToggleMenuInputHandler,
	list_menu_input_handler: ListMenuInputHandler,
	bag_menu_handler: BagMenuHandler,
	ui_updater: UseItemMenuUIUpdater,
	item_consumer: ItemConsumer,
) -> void:
	_menu = menu
	_state_data = state_data
	_list_menu_behaviour = list_menu_behaviour
	_use_item_menu_behaviour = use_item_menu_behaviour
	_toggle_menu_input_handler = toggle_menu_input_handler
	_list_menu_input_handler = list_menu_input_handler
	_bag_menu_handler = bag_menu_handler
	_ui_updater = ui_updater
	_item_consumer = item_consumer

func transition_state(
	new_state: UseItemMenu.State,
	state_data := UseItemMenuStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

func _emit_menu_hidden() -> void:
	_menu.emit_menu_hidden()

func _emit_menu_shown() -> void:
	_menu.emit_menu_shown()

func is_closed() -> bool:
	return false
