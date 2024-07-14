extends Node

@export
var bag_menu: Control

signal bag_opened
signal bag_closed

func _process(_delta):
	if Input.is_action_just_pressed("toggle_bag"):
		bag_menu.visible = not bag_menu.visible

		if bag_menu.visible:
			bag_opened.emit()
		else:
			bag_closed.emit()
