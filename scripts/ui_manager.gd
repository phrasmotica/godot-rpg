extends Node

@export
var bag_menu: Control

signal bag_opened

func _process(_delta):
	if not bag_menu.visible and Input.is_action_just_pressed("toggle_bag"):
		bag_menu.show()

		bag_opened.emit()
