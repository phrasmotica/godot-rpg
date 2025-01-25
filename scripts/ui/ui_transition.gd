@tool
class_name UITransition extends ColorRect

var _material := material as ShaderMaterial

enum Type { FADE_IN, FADE_OUT, BARS_UP, BARS_DOWN, BARS_ACROSS, SNAKE_FILL }

@export
var type: Type:
	set(value):
		type = value

		_refresh()

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

@onready
var fade_in_shader: Shader = load("res://resources/shaders/transition_fade_in.gdshader")

@onready
var fade_out_shader: Shader = load("res://resources/shaders/transition_fade_out.gdshader")

@onready
var bars_up_shader: Shader = load("res://resources/shaders/transition_bars_up.gdshader")

@onready
var bars_down_shader: Shader = load("res://resources/shaders/transition_bars_down.gdshader")

@onready
var bars_across_shader: Shader = load("res://resources/shaders/transition_bars_across.gdshader")

@onready
var snake_fill_shader: Shader = load("res://resources/shaders/transition_snake_fill.gdshader")

func _ready() -> void:
	_refresh()

func _refresh() -> void:
	if _material:
		_material.shader = _get_shader()

		_material.set_shader_parameter("enabled", enabled)
		_material.set_shader_parameter("to_colour", to_colour)

func _get_shader() -> Shader:
	if type == Type.FADE_IN:
		return fade_in_shader

	if type == Type.FADE_OUT:
		return fade_out_shader

	if type == Type.BARS_UP:
		return bars_up_shader

	if type == Type.BARS_DOWN:
		return bars_down_shader

	if type == Type.BARS_ACROSS:
		return bars_across_shader

	if type == Type.SNAKE_FILL:
		return snake_fill_shader

	return null
