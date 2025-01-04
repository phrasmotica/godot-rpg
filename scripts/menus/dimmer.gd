@tool
class_name Dimmer extends Node

@export
var to_dim: Control

@export
var is_dimmed := false:
	set(value):
		is_dimmed = value

		if is_dimmed:
			dim()
		else:
			undim()

signal dimmed
signal undimmed

func dim():
	if to_dim:
		print("Dimming " + to_dim.name)

		to_dim.modulate = Color.DARK_GRAY

		dimmed.emit()

func undim():
	if to_dim:
		print("Undimming " + to_dim.name)

		to_dim.modulate = Color.WHITE

		undimmed.emit()
