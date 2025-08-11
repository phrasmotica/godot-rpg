class_name PlayerStateData

var _move_direction := Vector2.ZERO

static func build() -> PlayerStateData:
	return PlayerStateData.new()

func with_move_direction(move_direction: Vector2) -> PlayerStateData:
	_move_direction = move_direction
	return self

func get_move_direction() -> Vector2:
	return _move_direction
