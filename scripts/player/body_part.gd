@tool
class_name BodyPart extends Resource

@export
var part_name := "":
    set(value):
        part_name = value

        emit_changed()

@export
var icon: Texture2D:
    set(value):
        icon = value

        emit_changed()

@export
var colours: ColourOption:
    set(value):
        colours = value

        emit_changed()

func init() -> void:
    if colours:
        colours.changed.connect(emit_changed)

func get_param_name() -> String:
    return colours.param_name

func get_colour() -> Color:
    return colours.get_colour()

func next_colour() -> void:
    colours.next()

func previous_colour() -> void:
    colours.previous()
