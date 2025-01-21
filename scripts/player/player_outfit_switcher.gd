@tool
extends VBoxContainer

@export
var torso_colour_index: int:
	set(value):
		torso_colour_index = clampi(value, 0, torso_colours.size() - 1)

		_refresh()

@export
var torso_colours: Array[Color] = []

@export
var sleeve_colour_index: int:
	set(value):
		sleeve_colour_index = clampi(value, 0, sleeve_colours.size() - 1)

		_refresh()

@export
var sleeve_colours: Array[Color] = []

@export
var outfit_nav_action: GUIDEAction

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

func _handle_outfit_nav() -> void:
	var dir := outfit_nav_action.value_axis_2d

	if dir == Vector2.RIGHT:
		torso_colour_index = (torso_colour_index + 1) % torso_colours.size()

	if dir == Vector2.LEFT:
		torso_colour_index = (torso_colour_index + torso_colours.size() - 1) % torso_colours.size()

	# HIGH: make up/down controls switch between customisation sections instead
	if dir == Vector2.DOWN:
		sleeve_colour_index = (sleeve_colour_index + 1) % sleeve_colours.size()

	if dir == Vector2.UP:
		sleeve_colour_index = (sleeve_colour_index + sleeve_colours.size() - 1) % sleeve_colours.size()

func _refresh() -> void:
	if _material:
		if torso_colours.size() > torso_colour_index:
			_material.set_shader_parameter("torso_colour", torso_colours[torso_colour_index])

		if sleeve_colours.size() > sleeve_colour_index:
			_material.set_shader_parameter("sleeve_colour", sleeve_colours[sleeve_colour_index])
