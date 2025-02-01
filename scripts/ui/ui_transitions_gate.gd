class_name UITransitionsGate extends Node

var _count := 0

func reset() -> void:
	_count = 0

func hold() -> void:
	_count += 1

func release() -> bool:
	if _count <= 0:
		return false

	_count -= 1

	return _count <= 0
