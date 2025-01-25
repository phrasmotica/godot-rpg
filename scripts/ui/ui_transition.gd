@tool
class_name UITransition extends ColorRect

var _material := material as ShaderMaterial

@export
var enabled := false:
	set(value):
		enabled = value

		_refresh()

@export
var to_colour: Color:
	set(value):
		to_colour = value

		_refresh()

func _ready() -> void:
	_refresh()

func _refresh() -> void:
	if _material:
		_material.set_shader_parameter("enabled", enabled)
		_material.set_shader_parameter("to_colour", to_colour)
