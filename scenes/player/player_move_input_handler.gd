class_name PlayerMoveInputHandler extends Node

@export
var grid_movement: GridMovement

## The number of seconds that a movement key must be held down before the player
## moves. This means if the key is not held down for that long, the player will
## face the new direction without moving.
@export_range(0.05, 0.2)
var tap_threshold_seconds := 0.1

@export
var move: GUIDEAction

signal face_triggered(direction: Vector2)
signal move_triggered(direction: Vector2)

func _ready() -> void:
	move.triggered.connect(_handle_move)

func _handle_move() -> void:
	var direction := move.value_axis_2d

	if not grid_movement.can_face(direction):
		return

	var already_facing := grid_movement.is_facing(direction)

	# if we're not already facing in the direction we want to move in, we should
	# be. Regardless of how long the input has been triggered for
	if not already_facing:
		face_triggered.emit(direction)

	if move.triggered_seconds >= tap_threshold_seconds or already_facing:
		move_triggered.emit(direction)
