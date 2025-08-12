@tool
class_name Player
extends CharacterBody2D

enum State { DISABLED, ENABLED, MOVING }

@export
var ui_manager: UIManager

@export
var party: Party

## The physics layers that the raycast should collide with when processing
## movement.
@export_flags_2d_physics
var raycast_mask: int

@export_group("Customisation")

@export
var torso_colour: Color:
	set(value):
		torso_colour = value

		_refresh()

@export
var sleeve_colour: Color:
	set(value):
		sleeve_colour = value

		_refresh()

@onready
var appearance: PlayerAppearance = %Appearance

@onready
var grid_movement: GridMovement = %GridMovement

@onready
var player_interact_input_handler: PlayerInteractInputHandler = %PlayerInteractInputHandler

@onready
var player_move_input_handler: PlayerMoveInputHandler = %PlayerMoveInputHandler

var _state_factory := PlayerStateFactory.new()
var _current_state: PlayerState = null

signal position_faced(pos: Vector2)
signal moving_to_position(pos: Vector2i)
signal moved_to_position(pos: Vector2i)
signal interacted
signal pickup_item(item: Item)

func _ready() -> void:
	_refresh()

	if Engine.is_editor_hint():
		return

	switch_state(State.ENABLED)

func switch_state(state: State, state_data := PlayerStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		ui_manager,
		party,
		grid_movement,
		appearance,
		player_interact_input_handler,
		player_move_input_handler)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "PlayerStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func emit_position_faced(pos: Vector2) -> void:
	position_faced.emit(pos)

func emit_moving_to_position(pos: Vector2i) -> void:
	moving_to_position.emit(pos)

func emit_moved_to_position(pos: Vector2i) -> void:
	moved_to_position.emit(pos)

func emit_interacted() -> void:
	interacted.emit()

func emit_pickup_item(item: Item) -> void:
	pickup_item.emit(item)

func _refresh() -> void:
	if _current_state:
		_current_state.refresh()
