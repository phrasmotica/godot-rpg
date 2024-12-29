class_name GridMovement extends Node2D

@export
var self_node: Node2D

@export
var speed := 0.35

@export
var step_size := 64

@export
var movement_animation: MovementAnimation

@export
var sprite: Sprite2D

@onready
var raycast: RayCast2D = $RayCast2D

var moving_direction := Vector2.ZERO
var facing_direction := Vector2.RIGHT

signal position_faced(pos: Vector2)
signal moving_started(pos: Vector2)
signal moving_finished(pos: Vector2)

func _ready():
    raycast.target_position = Vector2.RIGHT * step_size

func set_raycast_mask(mask: int):
    raycast.collision_mask = mask

func get_snapped_position(current_pos: Vector2):
    var snap_pos = current_pos.snapped(Vector2.ONE * step_size)
    snap_pos -= Vector2.ONE * float(step_size) / 2
    return snap_pos

func can_face(direction: Vector2):
    return moving_direction.length() == 0 and direction.length() > 0

func face(direction: Vector2) -> bool:
    if can_face(direction):
        raycast.target_position = direction * step_size
        raycast.force_raycast_update()

        var new_facing_direction = direction.normalized()
        var did_change = facing_direction != new_facing_direction

        facing_direction = new_facing_direction

        if did_change:
            check_facing_tile()

            if movement_animation:
                movement_animation.face_direction(direction)
            elif sprite:
                sprite.rotation = direction.angle()

        return did_change

    return false

func check_facing_tile():
    # global position of raycast target
    var facing_pos := raycast.global_position + raycast.target_position

    position_faced.emit(facing_pos)

func move_obey_collisions(direction: Vector2) -> void:
    _move(direction, raycast.is_colliding())

func move_ignore_collisions(direction: Vector2) -> void:
    _move(direction, false)

func move_ignore_collision_set(direction: Vector2, ignore_set: Array[CollisionShape2D]) -> void:
    var is_colliding := is_colliding_with(ignore_set)
    _move(direction, is_colliding)

## Returns whether we are colliding with a shape that ISN'T part of the ignore
## set. Adapted from the Raycast2D.get_collider_shape() GDScript docs.
func is_colliding_with(collision_ignore_set: Array[CollisionShape2D]) -> bool:
    var target := raycast.get_collider()

    if target and target is CollisionObject2D:
        var shape_id := raycast.get_collider_shape() # The shape index in the collider.

        var collision_obj := target as CollisionObject2D
        var owner_id := collision_obj.shape_find_owner(shape_id) # The owner ID in the collider.

        var shape: CollisionShape2D = target.shape_owner_get_owner(owner_id)

        return shape != null and collision_ignore_set.size() > 0 and not collision_ignore_set.has(shape)

    # this is required if we're colliding with a tile map layer
    return raycast.is_colliding()

func _move(direction: Vector2, is_colliding: bool) -> void:
    if moving_direction.length() == 0 and direction.length() > 0:
        var movement := Vector2.ZERO

        if direction.y > 0:
            movement = Vector2.DOWN
        elif direction.y < 0:
            movement = Vector2.UP
        elif direction.x > 0:
            movement = Vector2.RIGHT
        elif direction.x < 0:
            movement = Vector2.LEFT

        if not is_colliding:
            moving_direction = movement

            animate_move()

            if movement_animation:
                movement_animation.do_move(direction)

func animate_move():
    var new_position := self_node.global_position + (moving_direction * step_size)

    moving_started.emit(new_position)

    var tween := create_tween()
    tween.tween_property(self_node, "position", new_position, speed).set_trans(Tween.TRANS_LINEAR)
    tween.tween_callback(
        func():
            moving_direction = Vector2.ZERO
            moving_finished.emit(new_position)

            check_facing_tile()
    )
