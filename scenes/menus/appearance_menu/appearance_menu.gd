@tool
class_name AppearanceMenu extends Menu

enum State { DISABLED, ENABLED, COVERED }

@export
var toggle_menu_input_handler: ToggleMenuInputHandler

@onready
var list_menu_behaviour: ListMenu = %ListMenuBehaviour

@onready
var list_menu_input_handler: ListMenuInputHandler = %ListMenuInputHandler

@onready
var dimmer: Dimmer = %Dimmer

@onready
var next_frame_handler: NextFrameHandler = %NextFrameHandler

@onready
var ui_updater: AppearanceMenuUIUpdater = %UIUpdater

var _state_factory := AppearanceMenuStateFactory.new()
var _current_state: AppearanceMenuState = null

var _is_edit_mode := false

signal show_appearance_editor
signal hide_appearance_editor

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	visibility_changed.connect(_handle_visibility_changed)

	switch_state(State.DISABLED)

func switch_state(state: State, state_data := AppearanceMenuStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		ui_updater,
		dimmer,
		toggle_menu_input_handler,
		list_menu_input_handler)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "AppearanceMenuStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func _handle_select() -> void:
	var item := list_menu_behaviour.item()
	if item.disabled:
		return

	_is_edit_mode = true

	ui_updater.set_edit_mode()

	show_appearance_editor.emit()

func _handle_cancel() -> void:
	# doing this on the next frame ensures the menu set cannot listen for the
	# cancel input until after this menu has returned to normal mode
	next_frame_handler.on_next_frame(
		func():
			_is_edit_mode = false
	)

	ui_updater.set_normal_mode()

	hide_appearance_editor.emit()

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

func is_closed() -> bool:
	return _current_state and _current_state.is_closed()

func is_covered() -> bool:
	return _is_edit_mode or _current_state and _current_state.is_covered()
