class_name Player extends CharacterBody2D

@export
var sprite: AnimatedSprite2D

@export
var party: Party

@export
var move_action: GUIDEAction

@export
var interact_action: GUIDEAction

## The number of seconds that a movement key must be held down before the player
## moves. This means if the key is not held down for that long, the player will
## face the new direction without moving.
@export_range(0.05, 0.2)
var tap_threshold_seconds := 0.1

## The physics layers that the raycast should collide with when processing
## movement.
@export_flags_2d_physics
var raycast_mask: int

@onready
var grid_movement: GridMovement = %GridMovement

var move_timer_on := false

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

	move_action.triggered.connect(process_move)
	interact_action.triggered.connect(try_interact)

	moving_to_position.emit(global_position)

func process_move():
	var direction := move_action.value_axis_2d

	if direction.length() > 0:
		if not grid_movement.can_face(direction) or move_timer_on:
			return

		# TODO: implement facing logic via GUIDE tap triggers
		var did_change := grid_movement.face(direction)
		if did_change:
			set_move_timer(direction)
		else:
			# no need to wait for the player to face in the movement direction
			var party_colliders := party.get_colliders() if party else []
			grid_movement.move_ignore_collision_set(direction, party_colliders)

func set_move_timer(direction: Vector2):
	if direction.length() <= 0:
		return

	var move_timer := get_tree().create_timer(tap_threshold_seconds)
	move_timer_on = true

	# only move if the user has held down the key for long enough
	move_timer.timeout.connect(
		func():
			move_timer_on = false

			if move_action.value_axis_2d == direction:
				var party_colliders := party.get_colliders() if party else []
				grid_movement.move_ignore_collision_set(direction, party_colliders)
	)

func try_interact():
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
