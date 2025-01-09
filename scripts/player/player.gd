@tool
class_name Player extends CharacterBody2D

@export
var party_members: Array[NPC] = []:
	set(value):
		party_members = value

		if party:
			party.members = value

## The physics layers that the raycast should collide with when processing
## movement.
@export_flags_2d_physics
var raycast_mask: int

@onready
var sprite: AnimatedSprite2D = %Sprite

@onready
var grid_movement: GridMovement = %GridMovement

@onready
var party: Party = %Party

@onready
var movement_history: MovementHistory = %MovementHistory

@onready
var player_interact_input_handler: PlayerInteractInputHandler = %PlayerInteractInputHandler

@onready
var player_move_input_handler: PlayerMoveInputHandler = %PlayerMoveInputHandler

signal position_faced(pos: Vector2)
signal moving_to_position(pos: Vector2i)
signal moved_to_position(pos: Vector2i)
signal interacted
signal pickup_item(item: Item)
signal dialogue_triggered(npc: NPC)

func _ready():
	position = grid_movement.get_snapped_position(position)

	grid_movement.position_faced.connect(position_faced.emit)
	grid_movement.moving_started.connect(_handle_grid_movement_moving_started)
	grid_movement.moving_finished.connect(_handle_grid_movement_moving_finished)

	grid_movement.set_raycast_mask(raycast_mask)
	grid_movement.check_facing_tile()

	party.members = party_members

	player_interact_input_handler.dialogue_triggered.connect(_handle_dialogue_triggered)
	player_interact_input_handler.interacted.connect(interacted.emit)
	player_interact_input_handler.pickup_item_triggered.connect(_handle_pickup_item_triggered)

	player_move_input_handler.move_triggered.connect(_handle_move_triggered)

	_add_position(global_position)

func _handle_move_triggered(direction: Vector2):
	var party_colliders := party.get_colliders() if party else []
	grid_movement.move_ignore_collision_set(direction, party_colliders)

func _handle_dialogue_triggered(npc: NPC) -> void:
	npc.face(global_position)
	npc.enable_move = false

	dialogue_triggered.emit(npc)

	interacted.emit()

func _handle_pickup_item_triggered(item: Item) -> void:
	pickup_item.emit(item)

	interacted.emit()

func _handle_grid_movement_moving_started(pos: Vector2) -> void:
	_add_position(pos)

func _add_position(pos: Vector2) -> void:
	movement_history.add_position(pos)

	moving_to_position.emit(pos)

func _handle_grid_movement_moving_finished(pos: Vector2) -> void:
	sprite.stop()
	moved_to_position.emit(pos)
