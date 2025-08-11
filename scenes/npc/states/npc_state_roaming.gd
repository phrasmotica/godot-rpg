class_name NPCStateRoaming
extends NPCState

const POSSIBLE_DIRECTIONS: Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT,
]

func _enter_tree() -> void:
	print("%s is now roaming" % _npc.name)

	_move_timer.timeout.connect(_move)
	_move_timer.start(_npc.move_interval_seconds)

func _move() -> void:
	var dir: Vector2i = POSSIBLE_DIRECTIONS.pick_random()

	print("%s is moving in direction %s" % [_npc.name, dir])

	_grid_movement.face(dir)
	_grid_movement.move_obey_collisions(dir)

func is_interactable() -> bool:
	return true

func face_to(pos: Vector2) -> void:
	print("%s is being made to face position %s" % [_npc.name, pos])

	var dir: Vector2i = (pos - _npc.global_position).normalized()

	_grid_movement.face(dir)
