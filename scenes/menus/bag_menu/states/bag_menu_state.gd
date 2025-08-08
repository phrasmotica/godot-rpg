class_name BagMenuState
extends Node

signal state_transition_requested(new_state: BagMenu.State, state_data: BagMenuStateData)

var _menu: BagMenu = null
var _state_data: BagMenuStateData = null
var _ui_updater: BagMenuUIUpdater = null
var _dimmer: Dimmer = null
var _bag_handler: BagHandler = null
var _index_handler: ListIndexHandler = null
var _list_menu_input_handler: ListMenuInputHandler = null
var _menu_behaviour: BagMenuBehaviour = null
var _menu_items: BagMenuItems = null
var _use_item_menu: UseItemMenu = null

func setup(
	menu: BagMenu,
	state_data: BagMenuStateData,
	ui_updater: BagMenuUIUpdater,
	dimmer: Dimmer,
	index_handler: ListIndexHandler,
	bag_handler: BagHandler,
	list_menu_input_handler: ListMenuInputHandler,
	menu_behaviour: BagMenuBehaviour,
	menu_items: BagMenuItems,
	use_item_menu: UseItemMenu,
) -> void:
	_menu = menu
	_state_data = state_data
	_ui_updater = ui_updater
	_dimmer = dimmer
	_index_handler = index_handler
	_bag_handler = bag_handler
	_list_menu_input_handler = list_menu_input_handler
	_menu_behaviour = menu_behaviour
	_menu_items = menu_items
	_use_item_menu = use_item_menu

func transition_state(
	new_state: BagMenu.State,
	state_data := BagMenuStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

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
