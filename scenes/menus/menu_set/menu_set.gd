@tool
class_name MenuSet extends Control

enum State { DISABLED, HIDDEN, ENABLED }

@export
var current_menu_index := -1:
	set(value):
		var new_index: int = max(-1, min(menus.size() - 1, value))
		var index_changed := current_menu_index != new_index

		# MEDIUM: allow cycling the positions of each menu in the set
		# as the selected menu changes
		current_menu_index = new_index

		if index_changed:
			refresh()

@export
var menus: Array[Menu] = []

@export
var toggle_menu_input_handler: ToggleMenuInputHandler

@export
var menu_nav_action: GUIDEAction

var _state_factory := MenuSetStateFactory.new()
var _current_state: MenuSetState = null

signal opened
signal closed

func _ready() -> void:
	if menus.size() > 0:
		current_menu_index = 0
		switch_state(State.ENABLED)
	else:
		switch_state(State.DISABLED)

func switch_state(state: State, state_data := MenuSetStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		menus,
		toggle_menu_input_handler)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "MenuSetStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func to_hidden() -> void:
	switch_state(State.HIDDEN)

func emit_opened() -> void:
	opened.emit()

func emit_closed() -> void:
	closed.emit()

func refresh() -> void:
	for i in range(menus.size()):
		if i != current_menu_index:
			menus[i].disable()
		else:
			menus[i].enable()

func handle_menu_nav() -> void:
	var dir := menu_nav_action.value_axis_2d

	if dir == Vector2.RIGHT:
		current_menu_index = ((current_menu_index + 1) % menus.size())

	if dir == Vector2.LEFT:
		current_menu_index = ((current_menu_index + menus.size() - 1) % menus.size())
