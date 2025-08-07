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
		menu_set.opened.connect(menu_opened.emit)
		menu_set.closed.connect(menu_closed.emit)

		menu_set.to_hidden()

	ui_ready.emit()
