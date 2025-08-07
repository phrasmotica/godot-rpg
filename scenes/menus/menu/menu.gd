@tool
class_name Menu extends Control

enum State { DISABLED, ENABLED, COVERED }

@onready
var menu_state_handler: MenuStateHandler = %MenuStateHandler

var _state_factory := MenuStateFactory.new()
var _current_state: MenuState = null

signal cancel

signal menu_hidden(menu: Menu)
signal menu_shown(menu: Menu)

signal steal_control(menu: Menu)

func _ready() -> void:
	switch_state(State.DISABLED)

func switch_state(state: State, state_data := MenuStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "MenuStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func cancel_menu() -> void:
	cancel.emit()

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

func steal() -> void:
	if _current_state and _current_state.is_covered():
		_current_state.uncover()

		steal_control.emit(self)

func is_closed() -> bool:
	return _current_state and _current_state.is_closed()

func is_covered() -> bool:
	return _current_state and _current_state.is_covered()

func _handle_visibility_changed() -> void:
	if is_visible_in_tree():
		menu_shown.emit(self)
	else:
		menu_hidden.emit(self)

	after_visibility_changed()

func after_visibility_changed() -> void:
	pass
