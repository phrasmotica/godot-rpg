@tool
class_name Menu extends Control

var inactive := false:
	set(value):
		inactive = value

		update_process()

signal cancel

signal menu_hidden(menu: Menu)
signal menu_shown(menu: Menu)

signal menu_disabled(menu: Menu)
signal menu_enabled(menu: Menu)

signal steal_control(menu: Menu)

func _ready():
	update_process()

	after_ready()

func after_ready():
	pass

func _process(_delta):
	if Engine.is_editor_hint():
		return

	if Input.is_action_just_pressed("ui_cancel"):
		cancel_menu()

	listen_for_inputs()

func cancel_menu():
	cancel.emit()

func listen_for_inputs():
	pass

func disable_menu():
	print("Disabling menu " + name)

	inactive = true
	menu_disabled.emit(self)

	after_disable_menu()

func after_disable_menu():
	pass

func enable_menu():
	print("Enabling menu " + name)

	inactive = false
	menu_enabled.emit(self)

	after_enable_menu()

func after_enable_menu():
	pass

func _on_visibility_changed():
	update_process()

	if is_visible_in_tree():
		menu_shown.emit(self)
	else:
		menu_hidden.emit(self)

	after_visibility_changed()

func update_process():
	var is_process := not inactive and is_visible_in_tree()
	print(name + " process " + str(is_process))
	set_process(is_process)

func after_visibility_changed():
	pass
