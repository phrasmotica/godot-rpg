@tool
class_name UseItemMenu extends Menu

enum State { DISABLED, ENABLED, COVERED }

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
		list_menu_input_handler,
		bag,
		bag_menu,
		ui_updater,
		item_consumer,
		map)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "UseItemMenuStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

## Menu overrides

func cover() -> void:
	if _current_state:
		_current_state.cover()

func uncover() -> void:
	if _current_state:
		_current_state.uncover()

func is_closed() -> bool:
	return _current_state and _current_state.is_closed()

## UseItemMenu-specific

func emit_use() -> void:
	use.emit()

func emit_use_all() -> void:
	use_all.emit()

func emit_drop() -> void:
	drop.emit()

func emit_drop_all() -> void:
	drop_all.emit()
