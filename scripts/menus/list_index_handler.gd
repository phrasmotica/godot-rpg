@tool
class_name ListIndexHandler extends Node

@export
var current := -1:
	set(value):
		var is_changed = current != value

		current = value

		if is_changed:
			current_index_changed.emit(current)

signal current_index_changed(index: int)

func update(index: int) -> void:
	current = index

func clamp(max_index: int) -> void:
	current = clampi(current, 0, max_index)
