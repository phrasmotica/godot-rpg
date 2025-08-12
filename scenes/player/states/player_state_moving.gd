class_name PlayerStateMoving
extends PlayerState

func _enter_tree() -> void:
	print("%s is now moving" % _player.name)

	_grid_movement.moving_started.connect(_handle_moving_started)
	_grid_movement.moving_finished.connect(_handle_moving_finished)

	var direction := _state_data.get_move_direction()
	var party_colliders := _party.get_colliders() if _party else []

	_grid_movement.move_ignore_collision_set(direction, party_colliders)

func _handle_moving_started(pos: Vector2) -> void:
	_player.emit_moving_to_position(pos)

func _handle_moving_finished(pos: Vector2) -> void:
	_sprite.stop()
	_player.emit_moved_to_position(pos)

	transition_state(Player.State.ENABLED, _state_data)
