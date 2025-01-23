@tool
class_name BodyPartPool extends Resource

@export
var body_parts: Array[ColourOption] = []:
	set(value):
		body_parts = value

		emit_changed()

func _ready():
	for p in body_parts:
		p.changed.connect(emit_changed)

func size() -> int:
	return body_parts.size()

func get_part_name(index: int) -> String:
	return body_parts[index].option_name

func next_at(index: int) -> void:
	body_parts[index].next()

func previous_at(index: int) -> void:
	body_parts[index].previous()
