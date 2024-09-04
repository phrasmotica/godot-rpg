class_name NPC extends CharacterBody2D

@export
var talk_dialogue := "":
    set(value):
        talk_dialogue = value

        if dialogue_area:
            dialogue_area.timeline = talk_dialogue

@export_range(0.0, 10.0)
var move_interval_seconds := 5.0

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

func move():
    var dir: Vector2i = possible_directions.pick_random()

    print("NPC " + name + " moving in direction " + str(dir))

    grid_movement.face(dir)
    grid_movement.move(dir)
