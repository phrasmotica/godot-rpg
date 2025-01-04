class_name ToggleBagMenuInputHandler extends Node

@export
var toggle_bag_menu: GUIDEAction

signal toggled

func _ready() -> void:
	toggle_bag_menu.triggered.connect(toggled.emit)
