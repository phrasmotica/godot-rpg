@tool
class_name Menu extends Control

@export
var buttons: Array[MenuItem] = []

## The index of the selected menu item. Set to -1 for no item to be selected.
@export
var current_index := -1:
	set(value):
		current_index = min(max(value, -1), buttons.size() - 1)
		select_current()

signal select(index: int)
signal cancel

func _ready():
	set_process(visible)

	if buttons.size() > 0:
		current_index = 0

func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
		select.emit(current_index)

	if Input.is_action_just_pressed("ui_down"):
		next()

	if Input.is_action_just_pressed("ui_up"):
		previous()

	if Input.is_action_just_pressed("ui_cancel"):
		cancel.emit()

func next():
	if buttons.size() <= 0:
		return

	current_index = (current_index + 1) % buttons.size()

	select.emit(current_index)

func previous():
	if buttons.size() <= 0:
		return

	# this weird maths ensures we wrap around to the bottom of the bag
	# if we're currently at the top of it
	current_index = (current_index + buttons.size() - 1) % buttons.size()

	select.emit(current_index)

func _on_visibility_changed():
	select_current()

	set_process(visible)

func select_current():
	for i in range(buttons.size()):
		buttons[i].selected = i == current_index

	select.emit(current_index)
