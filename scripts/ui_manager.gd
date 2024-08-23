extends Node

@export
var menu: MenuSet

@export
var dialogue_manager: DialogueManager

var _dialogue_playing := false

signal menu_opened
signal menu_closed

func _ready():
	if dialogue_manager:
		dialogue_manager.timeline_started.connect(handle_dialogue_started)
		dialogue_manager.timeline_ended.connect(handle_dialogue_finished)

	hide_menu()

func handle_dialogue_started():
	_dialogue_playing = true

func handle_dialogue_finished():
	get_tree().process_frame.connect(
		func():
			_dialogue_playing = false
	, CONNECT_ONE_SHOT)

func hide_menu():
	menu.disable_menu()
	menu.hide()

func _process(_delta):
	if not menu.visible and not _dialogue_playing and Input.is_action_just_pressed("toggle_bag"):
		print("Showing menu")

		menu.show()

		menu_opened.emit()

		# ensures the key press doesn't immediately hide the menu
		var callable := menu.enable_menu.bind()
		get_tree().process_frame.connect(callable, CONNECT_ONE_SHOT)

func _on_menu_cancel():
	print("Hiding menu")

	hide_menu()

	menu_closed.emit()
