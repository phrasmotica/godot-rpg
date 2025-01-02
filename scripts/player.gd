class_name Player extends CharacterBody2D

@export
var sprite: AnimatedSprite2D

@export
var party: Party

## The physics layers that the raycast should collide with when processing
## movement.
@export_flags_2d_physics
var raycast_mask: int

@onready
var grid_movement: GridMovement = %GridMovement

@onready
var player_interact_input_handler: PlayerInteractInputHandler = %PlayerInteractInputHandler

@onready
var player_move_input_handler: PlayerMoveInputHandler = %PlayerMoveInputHandler

signal position_faced(pos: Vector2)
signal moving_to_position(pos: Vector2i)
signal moved_to_position(pos: Vector2i)
signal interacted
signal pickup_item(item: Item)
signal dialogue_triggered(timeline: String)

func _ready():
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

func _handle_move_triggered(direction: Vector2):
	var party_colliders := party.get_colliders() if party else []
	grid_movement.move_ignore_collision_set(direction, party_colliders)

func _handle_dialogue_triggered(npc: NPC) -> void:
	npc.face(global_position)
	dialogue_triggered.emit(npc.talk_dialogue)

	interacted.emit()

func _handle_pickup_item_triggered(item: Item) -> void:
	pickup_item.emit(item)

	interacted.emit()

func _handle_grid_movement_moving_finished(pos: Vector2):
	sprite.stop()
	moved_to_position.emit(pos)
