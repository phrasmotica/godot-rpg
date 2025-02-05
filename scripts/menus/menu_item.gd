@tool
class_name MenuItem extends VBoxContainer

@export
var text: String:
	set(value):
		text = value

		_refresh()

@export
var large_size := false:
	set(value):
		large_size = value

		_refresh()

@export
var selected := false:
	set(value):
		selected = value

		_refresh()

@export
var disabled := false:
	set(value):
		var changed := disabled != value
		disabled = value

		_refresh()

		if changed:
			if disabled:
				on_disabled.emit()
			else:
				on_enabled.emit()

@export
var is_cancel := false:
	set(value):
		is_cancel = value

		_refresh()

@onready
var pointer: TextureRect = %SelectionPointer

@onready
var name_label: Label = %Name

signal on_enabled
signal on_disabled

func _ready() -> void:
	_refresh()

func _refresh() -> void:
	if name_label:
		name_label.text = text

		name_label.modulate = Color.DARK_GRAY if disabled else Color.WHITE

		if is_cancel:
			name_label.theme_type_variation = "CancelLabel"
		else:
			name_label.theme_type_variation = "Label"

		if large_size and name_label.theme_type_variation.length() > 0:
			name_label.theme_type_variation = "Large" + name_label.theme_type_variation

	if pointer:
		pointer.visible = selected
