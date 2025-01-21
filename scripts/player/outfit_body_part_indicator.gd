@tool
class_name OutfitBodyPartIndicator extends VBoxContainer

@export_flags("Icons", "Label")
var display_mode: int = 1:
	set(value):
		display_mode = value

		_refresh()

@export
var current_index: int:
	set(value):
		current_index = clampi(value, 0, icons.size() - 1)

		_refresh()

@export
var icons: Array[BodyPartIconContainer] = []:
	set(value):
		icons = value

		_refresh()

@onready
var label: Label = %OptionLabel

@onready
var icons_box: HBoxContainer = %IconsBox

func set_text(text: String) -> void:
	if label:
		label.text = text

func _refresh() -> void:
	if label:
		label.visible = display_mode & 2

	if icons_box:
		icons_box.visible = display_mode & 1

	for i in icons.size():
		icons[i].is_selected = i == current_index
