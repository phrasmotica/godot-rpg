class_name MovementAnimation extends Node

@export
var sprite: AnimatedSprite2D

@export
var grid_movement: GridMovement

signal position_faced(pos: Vector2)

func face_direction(direction: Vector2) -> bool:
    var did_change = grid_movement.face(direction)
    if did_change:
        check_facing_tile()

        var new_anim = compute_animation(direction)
        if new_anim.length() > 0:
            sprite.animation = new_anim

    return did_change

func check_facing_tile():
    var raycast: RayCast2D = grid_movement.raycast

    # global position of raycast target
    var facing_pos := raycast.global_position + raycast.target_position

    position_faced.emit(facing_pos)

func do_move(direction: Vector2):
    var did_move = grid_movement.move(direction)
    if did_move and direction.length() > 0:
        sprite.play()

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
