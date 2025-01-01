class_name PlayerInputHandler extends Node

@export
var face: GUIDEAction

@export
var move: GUIDEAction

@export
var interact: GUIDEAction

signal move_triggered(direction: Vector2, triggered_seconds: float)
signal move_completed

signal interact_triggered

func _ready():
	move.triggered.connect(_handle_move)
	move.completed.connect(_handle_move_completed)

	interact.triggered.connect(interact_triggered.emit)

func _handle_move():
	var direction := get_move_direction()

	move_triggered.emit(direction, move.triggered_seconds)

func _handle_move_completed():
	move_completed.emit()

func get_move_direction() -> Vector2:
	return move.value_axis_2d
