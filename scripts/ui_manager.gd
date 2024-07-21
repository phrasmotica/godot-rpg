extends Node

@export
var menu: Control

signal menu_opened
signal menu_closed

func _ready():
	menu.hide()

func _process(_delta):
	if Input.is_action_just_pressed("toggle_bag"):
		if not menu.visible:
			print("Showing menu")

			menu.show()

			menu_opened.emit()
		else:
			print("Hiding menu")

			menu.hide()

			menu_closed.emit()
