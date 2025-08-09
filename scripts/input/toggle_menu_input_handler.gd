class_name ToggleMenuInputHandler extends Node

# TODO: turn this into an autoload

@export
var toggle_menu: GUIDEAction

signal toggled

func _ready() -> void:
	toggle_menu.triggered.connect(toggled.emit)
