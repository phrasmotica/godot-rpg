class_name PlayerInputHandler extends Node

@export
var face: GUIDEAction

@export
var move: GUIDEAction

@export
var interact: GUIDEAction

signal move_triggered(direction: Vector2)
signal interact_triggered

func _ready():
	move.triggered.connect(_handle_move)
	interact.triggered.connect(interact_triggered.emit)

func _handle_move():
	var direction := get_move_direction()

	move_triggered.emit(direction)

func get_move_direction() -> Vector2:
	return move.value_axis_2d
