extends Node

@export
var bag_menu: Control

func _process(_delta):
	if Input.is_action_just_pressed("toggle_bag"):
		bag_menu.visible = not bag_menu.visible
