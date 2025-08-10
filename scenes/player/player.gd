@tool
class_name Player
extends CharacterBody2D

enum State { DISABLED, ENABLED }

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
var sprite: AnimatedSprite2D = %Sprite

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

	switch_state(State.DISABLED)

	position = grid_movement.get_snapped_position(position)

	grid_movement.position_faced.connect(position_faced.emit)
	grid_movement.moving_started.connect(moving_to_position.emit)
	grid_movement.moving_finished.connect(_handle_grid_movement_moving_finished)

	grid_movement.set_raycast_mask(raycast_mask)
	grid_movement.check_facing_tile()

	player_interact_input_handler.dialogue_triggered.connect(_handle_dialogue_triggered)
	player_interact_input_handler.interacted.connect(interacted.emit)
	player_interact_input_handler.pickup_item_triggered.connect(_handle_pickup_item_triggered)

	player_move_input_handler.move_triggered.connect(_handle_move_triggered)

	moving_to_position.emit(global_position)

func switch_state(state: State, state_data := PlayerStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "PlayerStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func _refresh() -> void:
	if sprite:
		var shader := sprite.material as ShaderMaterial
		shader.set_shader_parameter("torso_colour", torso_colour)
		shader.set_shader_parameter("sleeve_colour", sleeve_colour)

func _handle_move_triggered(direction: Vector2):
	var party_colliders := party.get_colliders() if party else []
	grid_movement.move_ignore_collision_set(direction, party_colliders)

func _handle_dialogue_triggered(npc: NPC) -> void:
	npc.face(global_position)
	DialogueManager.start_timeline(npc.talk_dialogue)

	interacted.emit()

func _handle_pickup_item_triggered(item: Item) -> void:
	pickup_item.emit(item)

	interacted.emit()

func _handle_grid_movement_moving_finished(pos: Vector2):
	sprite.stop()
	moved_to_position.emit(pos)
