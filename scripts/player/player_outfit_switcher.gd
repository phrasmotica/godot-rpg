@tool
extends VBoxContainer

@export
var option_index: int:
	set(value):
		option_index = clampi(value, 0, body_parts.size() - 1)

		_refresh()

@export
var body_parts: BodyPartPool

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

	body_parts.changed.connect(_refresh)

	if Engine.is_editor_hint():
		return

	if outfit_nav_action:
		outfit_nav_action.triggered.connect(_handle_outfit_nav)

func _handle_outfit_nav() -> void:
	var dir := outfit_nav_action.value_axis_2d

	if dir == Vector2.RIGHT:
		body_parts.next_at(option_index)
		_refresh()

	if dir == Vector2.LEFT:
		body_parts.previous_at(option_index)
		_refresh()

	if dir == Vector2.DOWN:
		option_index = (option_index + 1) % body_parts.size()

	if dir == Vector2.UP:
		option_index = (option_index + body_parts.size() - 1) % body_parts.size()

func _refresh() -> void:
	body_part_indicator.current_index = option_index

	if _material:
		for p in body_parts.body_parts:
			_material.set_shader_parameter(p.get_param_name(), p.get_colour())
