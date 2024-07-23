extends Node

@export
var menu: MenuSet

signal menu_opened
signal menu_closed

func _ready():
	menu.start_loading()
	menu.hide()
	menu.finish_loading()

	# HIGH: rewrite menu loading/active/inactive/etc logic. Child menus should
	# be inactive exactly when they are not visible

func _process(_delta):
	if not menu.visible and Input.is_action_just_pressed("toggle_bag"):
		print("Showing menu")

		menu.show()

		menu_opened.emit()

func _on_menu_cancel():
	print("Hiding menu")

	menu.hide()

	menu_closed.emit()
