@tool
class_name NPC extends CharacterBody2D

@export
var npc_data: NPCData:
    set(value):
        npc_data = value

        _refresh()

@export
var enable_move := false:
    set(value):
        enable_move = value

        _refresh_movement()

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

var _was_moving_on_ready := false

var _possible_directions: Array[Vector2i] = [
    Vector2i.UP,
    Vector2i.RIGHT,
    Vector2i.DOWN,
    Vector2i.LEFT,
]

func _ready() -> void:
    npc_data.changed.connect(_refresh)

    if Engine.is_editor_hint():
        return

    collision_shape.shape = dialogue_area.get_area_shape()

    _was_moving_on_ready = enable_move
    _refresh_movement()

    grid_movement.set_raycast_mask(raycast_mask)

func _refresh() -> void:
    if dialogue_area:
        dialogue_area.timeline = npc_data.talk_dialogue

func _refresh_movement() -> void:
    if not move_timer:
        return

    var is_moving := move_timer.timeout.is_connected(_move)

    if enable_move and not is_moving:
        _start_moving()
    elif not enable_move and is_moving:
        _stop_moving()

func _start_moving() -> void:
    move_timer.timeout.connect(_move)
    move_timer.start(move_interval_seconds)

func _stop_moving() -> void:
    move_timer.timeout.disconnect(_move)
    move_timer.stop()

func resume_moving() -> void:
    if _was_moving_on_ready:
        _start_moving()

func get_talk_dialogue() -> String:
    if not npc_data:
        return ""

    if npc_data.item_trade:
        # TODO: instead, return a stock dialogue timeline with variables for the
        # item names
        return npc_data.talk_dialogue

    return npc_data.talk_dialogue

func _move() -> void:
    var dir: Vector2i = _possible_directions.pick_random()

    print("NPC " + name + " moving in direction " + str(dir))

    grid_movement.face(dir)
    grid_movement.move_obey_collisions(dir)

func face(pos: Vector2) -> void:
    print("NPC " + name + " facing position " + str(pos))

    var dir: Vector2i = (pos - global_position).normalized()

    grid_movement.face(dir)

func move_to(pos: Vector2, ignore_collision := false) -> void:
    print("NPC " + name + " is being moved to " + str(pos))

    var dir := (pos - global_position).normalized()

    grid_movement.face(dir)

    if ignore_collision:
        grid_movement.move_ignore_collisions(dir)
    else:
        grid_movement.move_obey_collisions(dir)
