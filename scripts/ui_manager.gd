@tool
class_name UIManager extends Node

@export
var menu_set: MenuSet

@export
var toggle_menu_input_handler: ToggleMenuInputHandler

@export
var dialogue_manager: DialogueManager

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

	if toggle_menu_input_handler:
		toggle_menu_input_handler.toggled.connect(_handle_toggle_menu)

	if dialogue_manager:
		dialogue_manager.choose_item_from_bag.connect(_handle_choose_item_from_bag)

	_hide_menu()

	ui_ready.emit()

func _show_menu() -> void:
	print("Showing menu set")

	menu_set.show()

	menu_opened.emit()

func _hide_menu() -> void:
	print("Hiding menu set")

	menu_set.hide()

	menu_closed.emit()

func _handle_toggle_menu() -> void:
	if not menu_set.visible:
		_show_menu()

func _handle_menu_cancel() -> void:
	# ensures the key press doesn't immediately show the menu
	next_frame_handler.on_next_frame(_hide_menu)

func _handle_choose_item_from_bag() -> void:
	print("Choosing item from bag")

	Dialogic.VAR.is_choosing_from_bag = true

	_show_menu()

	menu_closed.connect(_handle_menu_closed_after_choosing_from_bag, CONNECT_ONE_SHOT)

func _handle_menu_closed_after_choosing_from_bag() -> void:
	print("Choosing item from bag finished!")

	Dialogic.VAR.is_choosing_from_bag = false

	dialogue_manager.try_resume()
