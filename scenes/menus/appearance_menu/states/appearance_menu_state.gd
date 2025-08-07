class_name AppearanceMenuState
extends Node

signal state_transition_requested(new_state: AppearanceMenu.State, state_data: AppearanceMenuStateData)

var _menu: AppearanceMenu = null
var _state_data: AppearanceMenuStateData = null
var _ui_updater: AppearanceMenuUIUpdater = null
var _dimmer: Dimmer = null
var _toggle_menu_input_handler: ToggleMenuInputHandler = null
var _list_menu_behaviour: ListMenu = null
var _list_menu_input_handler: ListMenuInputHandler = null

func setup(
	menu: AppearanceMenu,
	state_data: AppearanceMenuStateData,
	ui_updater: AppearanceMenuUIUpdater,
	dimmer: Dimmer,
	toggle_menu_input_handler: ToggleMenuInputHandler,
	list_menu_behaviour: ListMenu,
	list_menu_input_handler: ListMenuInputHandler,
) -> void:
	_menu = menu
	_state_data = state_data
	_ui_updater = ui_updater
	_dimmer = dimmer
	_toggle_menu_input_handler = toggle_menu_input_handler
	_list_menu_behaviour = list_menu_behaviour
	_list_menu_input_handler = list_menu_input_handler

func transition_state(
	new_state: AppearanceMenu.State,
	state_data := AppearanceMenuStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

func _emit_menu_hidden() -> void:
	_menu.emit_menu_hidden()

func _emit_menu_shown() -> void:
	_menu.emit_menu_shown()

func disable() -> void:
	pass

func enable() -> void:
	pass

func cover() -> void:
	pass

func uncover() -> void:
	pass

func is_closed() -> bool:
	return false
