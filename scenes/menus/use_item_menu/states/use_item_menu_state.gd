class_name UseItemMenuState
extends Node

signal state_transition_requested(new_state: UseItemMenu.State, state_data: UseItemMenuStateData)

var _menu: UseItemMenu = null
var _state_data: UseItemMenuStateData = null
var _list_menu_behaviour: ListMenu = null
var _use_item_menu_behaviour: UseItemMenuBehaviour = null
var _toggle_menu_input_handler: ToggleMenuInputHandler = null
var _list_menu_input_handler: ListMenuInputHandler = null

func setup(
	menu: UseItemMenu,
	state_data: UseItemMenuStateData,
	list_menu_behaviour: ListMenu,
	use_item_menu_behaviour: UseItemMenuBehaviour,
	toggle_menu_input_handler: ToggleMenuInputHandler,
	list_menu_input_handler: ListMenuInputHandler,
) -> void:
	_menu = menu
	_state_data = state_data
	_list_menu_behaviour = list_menu_behaviour
	_use_item_menu_behaviour = use_item_menu_behaviour
	_toggle_menu_input_handler = toggle_menu_input_handler
	_list_menu_input_handler = list_menu_input_handler

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
