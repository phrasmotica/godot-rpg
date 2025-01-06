@tool
class_name UIManager extends Node

@export
var menu_set: MenuSet

@export
var toggle_menu_input_handler: ToggleMenuInputHandler

@onready
var next_frame_handler: NextFrameHandler = %NextFrameHandler

signal ui_ready
signal menu_opened
signal menu_closed

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	if menu_set:
		menu_set.cancel.connect(_handle_menu_cancel)

	toggle_menu_input_handler.toggled.connect(_handle_toggle_menu)

	hide_menu()

	ui_ready.emit()

func hide_menu() -> void:
	menu_set.hide()

func _handle_toggle_menu() -> void:
	if not menu_set.visible:
		print("Showing menu set")

		menu_set.show()

		menu_opened.emit()

func _handle_menu_cancel() -> void:
	print("Hiding menu set")

	# ensures the key press doesn't immediately show the menu
	next_frame_handler.on_next_frame(hide_menu)

	menu_closed.emit()
