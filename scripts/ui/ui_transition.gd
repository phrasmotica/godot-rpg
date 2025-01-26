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

func inject(params: UITransitionParams) -> void:
	# shaders are only loaded after the node is ready
	ready.connect(_update_params.bind(params), CONNECT_ONE_SHOT)

func _update_params(params: UITransitionParams) -> void:
	if _material:
		type = params.get_shader_type()

		_material.shader = _get_shader()

		var param_dict := params.get_shader_params()

		for k in param_dict.keys():
			_material.set_shader_parameter(k, param_dict[k])

		_material.set_shader_parameter("enabled", true)

		# HIGH: ensure the shader's time variable is 0.0 on ready.
		# Pass a float value in as a uniform?

func _refresh() -> void:
	if not Engine.is_editor_hint():
		return

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
