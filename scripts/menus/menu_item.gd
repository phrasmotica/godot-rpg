@tool
class_name MenuItem extends VBoxContainer

@export
var pointer: TextureRect

@export
var name_label: Label

@export
var text: String:
	set(value):
		text = value

		if name_label:
			name_label.text = text

@export
var selected := false:
	set(value):
		selected = value

		if pointer:
			pointer.visible = selected

@export
var disabled := false:
	set(value):
		disabled = value

		name_label.modulate = Color.DARK_GRAY if disabled else Color.WHITE

		if disabled:
			on_disabled.emit()
		else:
			on_enabled.emit()

@export
var is_cancel := false:
	set(value):
		is_cancel = value

		if name_label:
			if is_cancel:
				name_label.theme_type_variation = "CancelLabel"
			else:
				name_label.theme_type_variation = ""

signal on_enabled
signal on_disabled
