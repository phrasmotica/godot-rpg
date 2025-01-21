@tool
extends VBoxContainer

@export
var option_index: int:
	set(value):
		option_index = clampi(value, 0, colour_options.size() - 1)

		_refresh()

@export
var colour_options: Array[ColourOption]

@export
var outfit_nav_action: GUIDEAction

@onready
var body_part_indicator: OutfitBodyPartIndicator = %BodyPartIndicator

@onready
var player_preview: TextureRect = %PlayerPreview

var _material: ShaderMaterial

func _ready() -> void:
	if player_preview:
		_material = player_preview.material as ShaderMaterial

	if Engine.is_editor_hint():
		return

	if outfit_nav_action:
		outfit_nav_action.triggered.connect(_handle_outfit_nav)

	for o in colour_options:
		o.changed.connect(_refresh)

func _handle_outfit_nav() -> void:
	var dir := outfit_nav_action.value_axis_2d

	if dir == Vector2.RIGHT:
		colour_options[option_index].next()

	if dir == Vector2.LEFT:
		colour_options[option_index].previous()

	if dir == Vector2.DOWN:
		option_index = (option_index + 1) % colour_options.size()

	if dir == Vector2.UP:
		option_index = (option_index + colour_options.size() - 1) % colour_options.size()

func _refresh() -> void:
	body_part_indicator.current_index = option_index
	body_part_indicator.set_text(colour_options[option_index].option_name)

	if _material:
		for o in colour_options:
			_material.set_shader_parameter(o.param_name, o.get_colour())
