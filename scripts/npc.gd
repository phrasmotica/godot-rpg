class_name NPC extends CharacterBody2D

@export
var talk_dialogue := "":
    set(value):
        talk_dialogue = value

        if dialogue_area:
            dialogue_area.timeline = talk_dialogue

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

func _ready():
    collision_shape.shape = dialogue_area.get_area_shape()

    move_timer.timeout.connect(move)
    move_timer.start(move_interval_seconds)

    grid_movement.set_raycast_mask(raycast_mask)

func move():
    var dir: Vector2i = possible_directions.pick_random()

    print("NPC " + name + " moving in direction " + str(dir))

    grid_movement.face(dir)
    grid_movement.move(dir)

func face(pos: Vector2):
    print("NPC " + name + " facing position " + str(pos))

    var dir: Vector2i = (pos - global_position).normalized()

    grid_movement.face(dir)
