@tool
class_name BodyPartPool extends Resource

@export
var body_parts: Array[BodyPart] = []:
	set(value):
		body_parts = value

		emit_changed()

func _ready() -> void:
	for p in body_parts:
		p.changed.connect(emit_changed)

func size() -> int:
	return body_parts.size()

func get_part_name(index: int) -> String:
	return body_parts[index].part_name

func get_icon(index: int) -> Texture2D:
	return body_parts[index].icon

func next_at(index: int) -> void:
	body_parts[index].next_colour()

func previous_at(index: int) -> void:
	body_parts[index].previous_colour()
