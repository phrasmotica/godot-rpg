@tool
class_name ColourOption extends Resource

## The name of the shader parameter that this colour option should affect.
@export
var param_name := ""

@export
var colour_index: int:
	set(value):
		colour_index = clampi(value, 0, colours.size() - 1)

		emit_changed()

@export
var colours: Array[Color] = []:
	set(value):
		colours = value

		if colours.size() > 0:
			colour_index = 0

		emit_changed()

func get_colour() -> Color:
	return colours[colour_index]

func next() -> void:
	colour_index = (colour_index + 1) % colours.size()

func previous() -> void:
	colour_index = (colour_index + colours.size() - 1) % colours.size()
