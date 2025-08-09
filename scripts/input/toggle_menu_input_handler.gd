extends Node

var _toggle_menu: GUIDEAction = preload("res://resources/input/toggle_menu.tres")

signal toggled

func _ready() -> void:
	_toggle_menu.triggered.connect(toggled.emit)
