@tool
class_name Menu extends Control

@export
var items: Array[MenuItem] = []

## The index of the selected menu item. Set to -1 for no item to be selected.
@export
var current_index := -1:
	set(value):
		current_index = min(max(value, -1), items.size() - 1)
		select_current()

signal select(index: int)
signal cancel

func _ready():
	set_process(visible)

	if items.size() > 0:
		current_index = 0

func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
		var item := items[current_index]

		if item.is_cancel:
			cancel.emit()
		else:
			select.emit(current_index)

	if Input.is_action_just_pressed("ui_down"):
		next()

	if Input.is_action_just_pressed("ui_up"):
		previous()

	if Input.is_action_just_pressed("ui_cancel"):
		cancel.emit()

func next():
	if items.size() <= 0:
		return

	current_index = (current_index + 1) % items.size()

func previous():
	if items.size() <= 0:
		return

	# this weird maths ensures we wrap around to the bottom of the bag
	# if we're currently at the top of it
	current_index = (current_index + items.size() - 1) % items.size()

func _on_visibility_changed():
	select_current()

	set_process(visible)

func select_current():
	for i in range(items.size()):
		items[i].selected = i == current_index
