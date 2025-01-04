class_name ToggleMenuInputHandler extends Node

@export
var toggle_menu: GUIDEAction

signal toggled

func _ready() -> void:
	toggle_menu.triggered.connect(toggled.emit)
