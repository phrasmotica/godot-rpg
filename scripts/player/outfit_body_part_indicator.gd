@tool
class_name OutfitBodyPartIndicator extends VBoxContainer

@export_flags("Icons", "Label")
var display_mode: int = 3:
	set(value):
		display_mode = value

		_refresh()

@export
var current_index: int:
	set(value):
		current_index = clampi(value, 0, _icons.size() - 1)

		_refresh()

# HIGH: call _refresh() when a body part is added/removed in this scene's inspector
@export
var body_parts: BodyPartPool:
	set(value):
		body_parts = value

		_refresh()

@export
var icon_container_scene: PackedScene

@onready
var label: Label = %OptionLabel

@onready
var icons_box: HBoxContainer = %IconsBox

var _icons: Array[BodyPartIconContainer] = []

func _ready() -> void:
	_refresh()

func _refresh() -> void:
	if label:
		label.visible = display_mode & 2
		label.text = body_parts.get_part_name(current_index) if body_parts else ""

	if icons_box:
		icons_box.visible = display_mode & 1

		_ensure_icons()

	for i in _icons.size():
		_icons[i].is_selected = i == current_index

func _ensure_icons() -> void:
	if not body_parts:
		_trim_to(0)
		return

	var nodes := icons_box.get_children()

	var node_count := len(nodes)
	var data_count := body_parts.size()
	var count_changed := node_count != data_count

	for i in body_parts.size():
		var texture := body_parts.get_icon(i)

		if nodes.size() > i:
			var icon: BodyPartIconContainer = nodes[i]
			icon.texture = texture
		else:
			var icon: BodyPartIconContainer = icon_container_scene.instantiate()
			icon.texture = texture

			_icons.append(icon)

			icons_box.add_child(icon, true)
			icon.owner = self

	if not count_changed:
		return

	# clean up any unused icons
	_trim_to(body_parts.size())

	current_index = clampi(current_index, 0, _icons.size() - 1)

func _trim_to(trim_size: int) -> void:
	for j in range(trim_size, _icons.size()):
		_icons[j].queue_free()

	while _icons.size() > trim_size:
		_icons.pop_back()
