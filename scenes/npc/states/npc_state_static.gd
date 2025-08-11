class_name NPCStateStatic
extends NPCState

func _enter_tree() -> void:
	print("%s is now static" % _npc.name)

	_move_timer.stop()

func is_interactable() -> bool:
	return true

func face_to(pos: Vector2) -> void:
	print("%s is being made to face position %s" % [_npc.name, pos])

	var dir: Vector2i = (pos - _npc.global_position).normalized()

	_grid_movement.face(dir)
