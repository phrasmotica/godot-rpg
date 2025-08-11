class_name NPCStateInParty
extends NPCState

func _enter_tree() -> void:
	print("%s is now in party" % _npc.name)

func move_to(pos: Vector2, ignore_collision := false) -> void:
	print("%s is being moved to position %s" % [_npc.name, pos])

	var dir := (pos - _npc.global_position).normalized()

	_grid_movement.face(dir)

	if ignore_collision:
		_grid_movement.move_ignore_collisions(dir)
	else:
		_grid_movement.move_obey_collisions(dir)
