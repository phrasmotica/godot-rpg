@tool
class_name BodyPartIconContainer extends CenterContainer

@export
var texture: Texture2D:
	set(value):
		texture = value

		_refresh()

@export
var is_selected := false:
	set(value):
		is_selected = value

		_refresh()

@onready
var icon: TextureRect = %Icon

func _ready() -> void:
	_refresh()

func _refresh() -> void:
	if icon:
		icon.texture = texture
		icon.modulate = Color.WHITE if is_selected else Color.DIM_GRAY
