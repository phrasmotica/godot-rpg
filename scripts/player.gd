extends Node2D

@export_range(150, 300)
var speed := 150

func _process(delta):
	var x := compute_x()
	var y := compute_y()

	if x != 0 or y != 0:
		translate(delta * speed * Vector2(x, y).normalized())

func compute_x() -> int:
	var resultant := 0

	if Input.is_action_pressed("player_right"):
		resultant += 1

	if Input.is_action_pressed("player_left"):
		resultant -= 1

	return resultant

func compute_y() -> int:
	var resultant := 0

	if Input.is_action_pressed("player_down"):
		resultant += 1

	if Input.is_action_pressed("player_up"):
		resultant -= 1

	return resultant
