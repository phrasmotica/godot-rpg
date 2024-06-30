extends Node2D

@export
var sprite: AnimatedSprite2D

@export_range(150, 300)
var speed := 150

func _process(delta):
	var x := compute_x()
	var y := compute_y()

	if x != 0 or y != 0:
		var new_anim = compute_animation(x, y)
		if new_anim.length() > 0:
			sprite.animation = new_anim

		sprite.play()

		translate(delta * speed * Vector2(x, y).normalized())
	else:
		sprite.stop()

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

func compute_animation(_x: int, y: int) -> StringName:
	if y < 0:
		return "walk_up"

	if y > 0:
		return "walk_down"

	return ""
