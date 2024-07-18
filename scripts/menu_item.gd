@tool
class_name MenuItem extends Control

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
