extends CharacterBody2D

@export
var sprite: AnimatedSprite2D

@onready
var grid_movement = $GridMovement

func _ready():
	position = grid_movement.get_snapped_position(position)

func _process(_delta):
	var direction = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	var did_move = grid_movement.move(direction)

	if did_move and direction.length() > 0:
		var new_anim = compute_animation(direction)
		if new_anim.length() > 0:
			sprite.animation = new_anim

		sprite.play()

func compute_animation(direction: Vector2) -> StringName:
	if direction.y < 0:
		return "walk_up"

	if direction.y > 0:
		return "walk_down"

	return ""

func _on_grid_movement_moving_finished():
	sprite.stop()
