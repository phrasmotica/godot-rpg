extends Node

@export
var menu: MenuSet

signal menu_opened
signal menu_closed

func _ready():
	hide_menu()

func hide_menu():
	menu.disable_menu()
	menu.hide()

func _process(_delta):
	if not menu.visible and Input.is_action_just_pressed("toggle_bag"):
		print("Showing menu")

		menu.show()

		menu_opened.emit()

		# ensures the key press doesn't immediately hide the menu
		menu.call_deferred("enable_menu")

func _on_menu_cancel():
	print("Hiding menu")

	hide_menu()

	menu_closed.emit()
