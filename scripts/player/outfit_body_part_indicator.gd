@tool
class_name OutfitBodyPartIndicator extends HBoxContainer

@export
var current_index: int:
	set(value):
		current_index = clampi(value, 0, icons.size() - 1)

		_refresh()

@export
var icons: Array[TextureRect] = []:
	set(value):
		icons = value

		_refresh()

func _refresh() -> void:
	for i in icons.size():
		icons[i].modulate = Color.WHITE if i == current_index else Color.DIM_GRAY
