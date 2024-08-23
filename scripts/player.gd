class_name Player extends CharacterBody2D

@export
var sprite: AnimatedSprite2D

@export
var dialogue_manager: DialogueManager

## The number of seconds that a movement key must be held down before the player
## moves. This means if the key is not held down for that long, the player will
## face the new direction without moving.
@export_range(0.05, 0.2)
var tap_threshold_seconds := 0.1

@onready
var grid_movement = $GridMovement

var _dialogue_playing := false
var move_timer_on := false

signal position_faced(pos: Vector2)
signal interacted
signal pickup_item(item: Item)

func _ready():
	if dialogue_manager:
		dialogue_manager.timeline_started.connect(handle_dialogue_started)
		dialogue_manager.timeline_ended.connect(handle_dialogue_finished)

	position = grid_movement.get_snapped_position(position)

	check_facing_tile()

func handle_dialogue_started():
	_dialogue_playing = true

func handle_dialogue_finished():
	get_tree().process_frame.connect(
		func():
			_dialogue_playing = false
	, CONNECT_ONE_SHOT)

func _process(_delta):
	if not _dialogue_playing:
		process_move()

		if Input.is_action_just_pressed("pick_up"):
			try_pickup_item()

func process_move():
	var direction := Input.get_vector("player_left", "player_right", "player_up", "player_down")

	if direction.length() > 0:
		if not grid_movement.can_face(direction) or move_timer_on:
			return

		var did_change := face_direction(direction)
		if did_change:
			set_move_timer(direction)
		else:
			# no need to wait for the player to face in the movement direction
			do_move(direction)

func face_direction(direction: Vector2) -> bool:
	var did_change = grid_movement.face(direction)
	if did_change:
		check_facing_tile()

		var new_anim = compute_animation(direction)
		if new_anim.length() > 0:
			sprite.animation = new_anim

	return did_change

func set_move_timer(direction: Vector2):
	if direction.length() <= 0:
		return

	var move_timer := get_tree().create_timer(tap_threshold_seconds)
	move_timer_on = true

	# only move if the user has held down the key for long enough
	move_timer.timeout.connect(
		func():
			move_timer_on = false

			var action = compute_input_action(direction)

			if Input.is_action_pressed(action):
				do_move(direction)
	)

func do_move(direction: Vector2):
	var did_move = grid_movement.move(direction)
	if did_move and direction.length() > 0:
		sprite.play()

func try_pickup_item():
	var collider = grid_movement.raycast.get_collider()
	if collider and collider is ItemArea:
		var item_area = collider as ItemArea
		var item := item_area.get_item()
		pickup_item.emit(item)

		item_area.dispose()
		return

	interacted.emit()

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

	check_facing_tile()

func check_facing_tile():
	var raycast: RayCast2D = grid_movement.raycast

	# global position of raycast target
	var facing_pos := raycast.global_position + raycast.target_position

	position_faced.emit(facing_pos)

func _on_ui_manager_menu_opened():
	prevent_input()

func _on_ui_manager_menu_closed():
	allow_input()

func prevent_input():
	set_process(false)

func allow_input():
	# this ensures that this script processes against from the NEXT frame
	var callable := set_process.bind(true)
	get_tree().process_frame.connect(callable, CONNECT_ONE_SHOT)
