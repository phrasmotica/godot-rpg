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

@onready
var movement_animation: MovementAnimation = %MovementAnimation

var _dialogue_playing := false
var move_timer_on := false

signal position_faced(pos: Vector2)
signal interacted
signal pickup_item(item: Item)
signal dialogue_triggered(timeline: String)

func _ready():
	if dialogue_manager:
		dialogue_manager.timeline_started.connect(handle_dialogue_started)
		dialogue_manager.timeline_ended.connect(handle_dialogue_finished)

	position = grid_movement.get_snapped_position(position)

	if movement_animation:
		movement_animation.position_faced.connect(position_faced.emit)

		movement_animation.check_facing_tile()

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
			try_interact()

func process_move():
	var direction := Input.get_vector("player_left", "player_right", "player_up", "player_down")

	if direction.length() > 0:
		if not grid_movement.can_face(direction) or move_timer_on:
			return

		var did_change := movement_animation.face_direction(direction)
		if did_change:
			set_move_timer(direction)
		else:
			# no need to wait for the player to face in the movement direction
			movement_animation.do_move(direction)

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
				movement_animation.do_move(direction)
	)

func try_interact():
	var collider = grid_movement.raycast.get_collider()
	if collider:
		if collider is ItemArea:
			var item_area = collider as ItemArea
			var item := item_area.get_item()
			pickup_item.emit(item)

			item_area.dispose()
			return

		if collider is NPC:
			var npc = collider as NPC
			dialogue_triggered.emit(npc.talk_dialogue)

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

func _on_grid_movement_moving_finished():
	sprite.stop()

	movement_animation.check_facing_tile()

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
