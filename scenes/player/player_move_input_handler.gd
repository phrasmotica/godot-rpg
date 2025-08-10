class_name PlayerMoveInputHandler extends Node

@export
var grid_movement: GridMovement

## The number of seconds that a movement key must be held down before the player
## moves. This means if the key is not held down for that long, the player will
## face the new direction without moving.
@export_range(0.05, 0.2)
var tap_threshold_seconds := 0.1

@export
var face: GUIDEAction

@export
var move: GUIDEAction

# TODO: create a MOVING state for the Player, so that this flag isn't required
var _facing_computed := false

signal face_triggered(direction: Vector2)
signal move_triggered(direction: Vector2)

func _ready() -> void:
	move.triggered.connect(_handle_move)
	move.completed.connect(_handle_move_completed)

func _handle_move() -> void:
	var direction := move.value_axis_2d

	if not grid_movement.can_face(direction):
		return

	var already_facing := grid_movement.is_facing(direction)

	# if we're not already facing in the direction we want to move in, we should
	# be. Regardless of how long the input has been triggered for
	if not already_facing and not _facing_computed:
		face_triggered.emit(direction)
		_facing_computed = true

	var do_move := (
		move.triggered_seconds >= tap_threshold_seconds or

		# player was already facing the correct way when move trigger STARTED
		(already_facing and not _facing_computed)
	)

	if not do_move:
		return

	if _facing_computed:
		# facing direction should be recomputed for the next move trigger
		_facing_computed = false

	move_triggered.emit(direction)

func _handle_move_completed() -> void:
	# facing direction should be recomputed for the next move trigger
	_facing_computed = false
