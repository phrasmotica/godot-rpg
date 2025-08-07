@tool
class_name AppearanceMenu extends Menu

enum State { DISABLED, ENABLED, EDITING }

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
		list_menu_behaviour,
		list_menu_input_handler)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "AppearanceMenuStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

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
