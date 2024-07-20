@tool
class_name Menu extends Control

@export
var items: Array[MenuItem] = []

## The index of the selected menu item. Set to -1 for no item to be selected.
@export
var current_index := -1:
	set(value):
		var new_index = min(max(value, -1), get_max_index())
		var is_changed = current_index != value

		current_index = new_index
		highlight_current()

		if is_changed:
			current_index_changed.emit(current_index)

signal current_index_changed(index: int)
signal select_index(index: int)
signal cancel

func _ready():
	set_process(visible)

	if items.size() > 0:
		current_index = 0

func _process(_delta):
	if Engine.is_editor_hint():
		return

	if Input.is_action_just_pressed("ui_select"):
		process_select()

	if Input.is_action_just_pressed("ui_down"):
		next()

	if Input.is_action_just_pressed("ui_up"):
		previous()

	if Input.is_action_just_pressed("ui_cancel"):
		cancel_menu()

	listen_for_inputs()

func process_select():
	var item := items[current_index]
	if item.disabled:
		return

	if item.is_cancel:
		cancel_menu()
	else:
		select_current()

func select_current():
	select_index.emit(current_index)

func next():
	if items.size() <= 0:
		return

	current_index = (current_index + 1) % items.size()

func previous():
	if items.size() <= 0:
		return

	# this weird maths ensures we wrap around to the bottom
	# if we're currently at the top
	current_index = (current_index + items.size() - 1) % items.size()

func cancel_menu():
	cancel.emit()

func listen_for_inputs():
	pass

func highlight_current():
	for i in range(items.size()):
		items[i].selected = i == current_index

func get_max_index():
	return items.size() - 1

func _on_visibility_changed():
	highlight_current()

	set_process(visible)
