extends Node2D

@export
var self_node: Node2D

@export
var speed := 0.35

@export
var step_size := 80

var moving_direction := Vector2.ZERO

signal moving_finished

func get_snapped_position(current_pos: Vector2):
    var snap_pos = current_pos.snapped(Vector2.ONE * step_size)
    snap_pos -= Vector2.ONE * float(step_size) / 2
    return snap_pos

func move(direction: Vector2):
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

        moving_direction = movement

        animate_move()

func animate_move():
    var new_position = self_node.global_position + (moving_direction * step_size)

    var tween := create_tween()
    tween.tween_property(self_node, "position", new_position, speed).set_trans(Tween.TRANS_LINEAR)
    tween.tween_callback(
        func():
            moving_direction = Vector2.ZERO
            moving_finished.emit()
    )
