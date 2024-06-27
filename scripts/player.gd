extends Node2D

@export_range(150, 300)
var speed := 150

func _process(delta):
	var direction := Vector2.ZERO

	if Input.is_action_pressed("player_right"):
		direction.x = 1

	if Input.is_action_pressed("player_down"):
		direction.y = 1

	if Input.is_action_pressed("player_left"):
		direction.x = -1

	if Input.is_action_pressed("player_up"):
		direction.y = -1

	if direction.length() > 0:
		print(str(direction.length()))
		position += delta * direction.normalized()
