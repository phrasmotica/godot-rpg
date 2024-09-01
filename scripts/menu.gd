@tool
class_name Menu extends Control

## Whether the content of this menu should become hidden when
## this menu is dimmed (content node can be chosen).
@export
var dimming_hides_content := false

@export
var dialogue_manager: DialogueManager

var _inactive := false
var _dialogue_playing := false

signal cancel

signal menu_hidden(menu: Menu)
signal menu_shown(menu: Menu)

signal menu_disabled(menu: Menu)
signal menu_enabled(menu: Menu)

signal steal_control(menu: Menu)

func _ready():
	if Engine.is_editor_hint():
		return

	if dialogue_manager:
		dialogue_manager.timeline_started.connect(
			func():
				_dialogue_playing = true
		)

		dialogue_manager.timeline_ended.connect(
			func():
				get_tree().process_frame.connect(handle_dialogue_finished, CONNECT_ONE_SHOT)
		)

	after_ready()

func handle_dialogue_finished():
	_dialogue_playing = false

func after_ready():
	pass

func _process(_delta):
	if Engine.is_editor_hint():
		return

	if can_listen():
		if Input.is_action_just_pressed("ui_cancel"):
			cancel_menu()

		listen_for_inputs()

func can_listen():
	return not _inactive and not _dialogue_playing and is_visible_in_tree()

func cancel_menu():
	cancel.emit()

func listen_for_inputs():
	pass

func disable_menu():
	print("Disabling menu " + name)

	_inactive = true
	menu_disabled.emit(self)

	after_disable_menu()

func after_disable_menu():
	pass

func enable_menu():
	print("Enabling menu " + name)

	_inactive = false
	menu_enabled.emit(self)

	after_enable_menu()

func after_enable_menu():
	pass

func steal():
	steal_control.emit(self)

func _on_visibility_changed():
	if is_visible_in_tree():
		menu_shown.emit(self)
	else:
		menu_hidden.emit(self)

	after_visibility_changed()

func after_visibility_changed():
	pass

func _on_dimmer_dimmed():
	if dimming_hides_content:
		hide_content()

	after_dimmed()

func _on_dimmer_undimmed():
	show_content()

	after_undimmed()

func hide_content():
	pass

func after_dimmed():
	pass

func show_content():
	pass

func after_undimmed():
	pass
