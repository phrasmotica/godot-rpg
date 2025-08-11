class_name NPC extends CharacterBody2D

enum State { ENABLED }

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

var possible_directions: Array[Vector2i] = [
    Vector2i.UP,
    Vector2i.RIGHT,
    Vector2i.DOWN,
    Vector2i.LEFT,
]

var _state_factory := NPCStateFactory.new()
var _current_state: NPCState = null

func _ready():
    collision_shape.shape = dialogue_area.get_area_shape()

    if enable_move:
        move_timer.timeout.connect(move)
        move_timer.start(move_interval_seconds)

    grid_movement.set_raycast_mask(raycast_mask)

    switch_state(State.ENABLED)

func switch_state(state: State, state_data := NPCStateData.new()) -> void:
    if _current_state != null:
        _current_state.queue_free()

    _current_state = _state_factory.get_fresh_state(state)

    _current_state.setup(
        self,
        state_data)

    _current_state.state_transition_requested.connect(switch_state)
    _current_state.name = "NPCStateMachine: %s" % str(state)

    call_deferred("add_child", _current_state)

func move():
    var dir: Vector2i = possible_directions.pick_random()

    print("NPC " + name + " moving in direction " + str(dir))

    grid_movement.face(dir)
    grid_movement.move_obey_collisions(dir)

func face(pos: Vector2):
    print("NPC " + name + " facing position " + str(pos))

    var dir: Vector2i = (pos - global_position).normalized()

    grid_movement.face(dir)

func move_to(pos: Vector2, ignore_collision := false):
    print("NPC " + name + " is being moved to " + str(pos))

    var dir := (pos - global_position).normalized()

    grid_movement.face(dir)

    if ignore_collision:
        grid_movement.move_ignore_collisions(dir)
    else:
        grid_movement.move_obey_collisions(dir)
