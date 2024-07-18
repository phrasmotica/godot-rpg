extends CharacterBody2D

@export
var sprite: AnimatedSprite2D

## The number of seconds that a movement key must be held down before the player
## moves. This means if the key is not held down for that long, the player will
## face the new direction without moving.
@export_range(0.05, 0.2)
var tap_threshold_seconds := 0.1

@onready
var grid_movement = $GridMovement

func _ready():
	position = grid_movement.get_snapped_position(position)

func _process(_delta):
	var direction := Input.get_vector("player_left", "player_right", "player_up", "player_down")

	if direction.length() > 0:
		face_direction(direction)

		# TODO: move immediately if player is already
		# facing in the movement direction
		set_move_timer(direction)

func face_direction(direction: Vector2):
	grid_movement.face(direction)

	var new_anim = compute_animation(direction)
	if new_anim.length() > 0:
		sprite.animation = new_anim

func set_move_timer(direction: Vector2):
	if direction.length() <= 0:
		return

	var move_timer = get_tree().create_timer(tap_threshold_seconds)

	# only move if the user has held down the key for long enough
	move_timer.timeout.connect(
		func():
			var action = compute_input_action(direction)

			if Input.is_action_pressed(action):
				do_move(direction)
	)

func do_move(direction: Vector2):
	var did_move = grid_movement.move(direction)
	if did_move and direction.length() > 0:
		sprite.play()

func compute_input_action(direction: Vector2) -> StringName:
	if direction.y > 0:
		return "player_down"

	if direction.y < 0:
		return "player_up"

	if direction.x > 0:
		return "player_right"

	if direction.x < 0:
		return "player_left"

	return ""

func compute_animation(direction: Vector2) -> StringName:
	if direction.y > 0:
		return "walk_down"

	if direction.y < 0:
		return "walk_up"

	if direction.x > 0:
		return "walk_right"

	if direction.x < 0:
		return "walk_left"

	return ""

func _on_grid_movement_moving_finished():
	sprite.stop()

func _on_ui_manager_bag_opened():
	set_process(false)

func _on_bag_menu_bag_closed():
	set_process(true)
