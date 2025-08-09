extends Node

var _toggle: GUIDEAction = preload("res://resources/input/toggle_debug_mode.tres")

signal toggled

func _ready() -> void:
    _toggle.triggered.connect(toggled.emit)
