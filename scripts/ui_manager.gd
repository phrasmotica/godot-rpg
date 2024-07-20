extends Node

@export
var menu: Control

signal menu_opened
signal menu_closed

func _ready():
	menu.hide()

func _process(_delta):
	if not menu.visible and Input.is_action_just_pressed("toggle_bag"):
		print("Showing menu")

		menu.show()

		menu_opened.emit()

func _on_bag_menu_bag_closed():
	print("Hiding menu")

	menu.hide()

	menu_closed.emit()
