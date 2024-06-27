extends Node2D

@export_range(150, 300)
var speed := 150

func _process(delta):
	if Input.is_action_pressed("player_right"):
		position.x += delta * speed

	if Input.is_action_pressed("player_down"):
		position.y += delta * speed

	if Input.is_action_pressed("player_left"):
		position.x -= delta * speed

	if Input.is_action_pressed("player_up"):
		position.y -= delta * speed
