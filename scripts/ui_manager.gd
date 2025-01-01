class_name UIManager extends Node

@export
var menu: MenuSet

@export
var toggle_bag_menu_input_handler: ToggleBagMenuInputHandler

signal ui_ready
signal menu_opened
signal menu_closed

func _ready():
	toggle_bag_menu_input_handler.toggled.connect(_handle_toggle_bag_menu)

	hide_menu()

	ui_ready.emit()

func hide_menu():
	menu.disable_menu()
	menu.hide()

func _handle_toggle_bag_menu() -> void:
	if not menu.visible:
		print("Showing menu")

		menu.show()

		menu_opened.emit()

		menu.enable_menu()

func _on_menu_cancel():
	print("Hiding menu")

	# ensures the key press doesn't immediately show the menu
	get_tree().process_frame.connect(hide_menu, CONNECT_ONE_SHOT)

	menu_closed.emit()
