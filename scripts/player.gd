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
var player_input_handler: PlayerInputHandler = %PlayerInputHandler

signal position_faced(pos: Vector2)
signal moving_to_position(pos: Vector2i)
signal moved_to_position(pos: Vector2i)
signal interacted
signal pickup_item(item: Item)
signal dialogue_triggered(timeline: String)

func _ready():
	position = grid_movement.get_snapped_position(position)

	if grid_movement:
		grid_movement.position_faced.connect(position_faced.emit)
		grid_movement.moving_started.connect(moving_to_position.emit)
		grid_movement.moving_finished.connect(moved_to_position.emit)

		grid_movement.set_raycast_mask(raycast_mask)
		grid_movement.check_facing_tile()

	player_input_handler.move_triggered.connect(_handle_move_triggered)
	player_input_handler.interact_triggered.connect(_handle_interact_triggered)

	moving_to_position.emit(global_position)

func _handle_move_triggered(direction: Vector2):
	var party_colliders := party.get_colliders() if party else []
	grid_movement.move_ignore_collision_set(direction, party_colliders)

func _handle_interact_triggered():
	var collider = grid_movement.raycast.get_collider()

	if not collider:
		return

	if collider is ItemArea:
		var item_area = collider as ItemArea
		var item := item_area.get_item()
		pickup_item.emit(item)

		item_area.dispose()

	elif collider is NPC:
		var npc := collider as NPC
		npc.face(global_position)

		dialogue_triggered.emit(npc.talk_dialogue)

	interacted.emit()

func _on_grid_movement_moving_finished(_pos: Vector2):
	sprite.stop()
