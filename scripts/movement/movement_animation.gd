class_name MovementAnimation extends Node

@export
var sprite: AnimatedSprite2D

func face_direction(direction: Vector2) -> void:
    var new_anim = compute_animation(direction)
    if new_anim.length() > 0:
        sprite.animation = new_anim

func do_move(direction: Vector2):
    if direction.length() > 0:
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
