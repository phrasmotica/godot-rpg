class_name NPC extends CharacterBody2D

enum State { DISABLED, STATIC, IN_PARTY, ENABLED }

@export
var talk_dialogue := "":
	set(value):
		talk_dialogue = value

		if dialogue_area:
			dialogue_area.timeline = talk_dialogue

@export
var enable_move := false

@export_range(0.0, 10.0)
var move_interval_seconds := 5.0

## The physics layers that the raycast should collide with when processing
## movement.
@export_flags_2d_physics
var raycast_mask: int

@onready
var grid_movement: GridMovement = %GridMovement

@onready
var dialogue_area: DialogueArea = %DialogueArea

@onready
var move_timer: Timer = %MoveTimer

@onready
var collision_shape: CollisionShape2D = %CollisionShape2D

var _state_factory := NPCStateFactory.new()
var _current_state: NPCState = null

func _ready() -> void:
	collision_shape.shape = dialogue_area.get_area_shape()

	grid_movement.set_raycast_mask(raycast_mask)

	if enable_move:
		switch_state(State.ENABLED)
	else:
		switch_state(State.STATIC)

func switch_state(state: State, state_data := NPCStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		grid_movement,
		move_timer)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "NPCStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func add_to_party() -> void:
	switch_state(State.IN_PARTY)

func is_interactable() -> bool:
	return _current_state and _current_state.is_interactable()

func face_to(pos: Vector2) -> void:
	if _current_state:
		_current_state.face_to(pos)

func move_to(pos: Vector2, ignore_collision: bool) -> void:
	if _current_state:
		_current_state.move_to(pos, ignore_collision)
