@tool
class_name BagMenu extends Menu

enum State { DISABLED, ENABLED, COVERED }

# HIGH: cut down on inheritance as much as possible

@export_group("Dependencies")

@export
var bag: Bag

@export
var child_menu_handler: ChildMenuHandler

@export
var use_item_menu: UseItemMenu

@onready
var menu_behaviour: BagMenuBehaviour = %BagMenuBehaviour

@onready
var list_menu_input_handler: ListMenuInputHandler = %ListMenuInputHandler

@onready
var ui_updater: BagMenuUIUpdater = %UIUpdater

signal select_stack(stack: ItemStack)

signal use_item(stack_id: int)
signal drop_item(stack_id: int)
signal drop_stack(stack_id: int)

signal selected_item_changed(item: Item)

var _state_factory := BagMenuStateFactory.new()
var _current_state: BagMenuState = null

func _ready() -> void:
	menu_behaviour.clamp()

	if Engine.is_editor_hint():
		return

	switch_state(State.DISABLED)

func switch_state(state: State, state_data := BagMenuStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		ui_updater,
		list_menu_input_handler,
		menu_behaviour,
		use_item_menu,
		bag,
		child_menu_handler)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "BagMenuStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

## Menu overrides

func disable() -> void:
	if _current_state:
		_current_state.disable()

func enable() -> void:
	if _current_state:
		_current_state.enable()

func cover() -> void:
	if _current_state:
		_current_state.cover()

func uncover() -> void:
	if _current_state:
		_current_state.uncover()

## BagMenu-specific

func emit_select_stack(stack: ItemStack) -> void:
	select_stack.emit(stack)

func emit_selected_item_changed(item: Item) -> void:
	selected_item_changed.emit(item)

func emit_use_item(stack_id: int) -> void:
	# HIGH: ensure this menu stays covered while triggered dialogue is in
	# progress. This will probably be easier to fix once UseItemMenu has been
	# refactored
	use_item.emit(stack_id)

func emit_drop_item(stack_id: int) -> void:
	drop_item.emit(stack_id)

func emit_drop_stack(stack_id: int) -> void:
	drop_stack.emit(stack_id)
