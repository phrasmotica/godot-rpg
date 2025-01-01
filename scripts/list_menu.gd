@tool
class_name ListMenu extends Menu

@export
var items: Array[MenuItem] = []

@export
var menu_nav_action: GUIDEAction

@export
var menu_select_action: GUIDEAction

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

func _ready():
	if Engine.is_editor_hint():
		return

	toggle_bag_menu_input_handler.toggled.connect(_handle_toggle_bag_menu)
	menu_nav_action.triggered.connect(handle_menu_nav)
	menu_select_action.triggered.connect(handle_menu_select)

	if items.size() > 0:
		current_index = 0

func handle_menu_nav() -> void:
	var dir := menu_nav_action.value_axis_2d

	if dir == Vector2.DOWN:
		print("Moving to next item")

		next()

	if dir == Vector2.UP:
		print("Moving to previous item")

		previous()

func handle_menu_select() -> void:
	if can_listen():
		print(name + " can listen, handling menu select")
		process_select()
	else:
		print(name + " cannot listen!")

func get_max_index():
	return items.size() - 1

func highlight_current():
	for i in range(items.size()):
		items[i].selected = i == current_index

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

	var i := 0
	while i == 0 or items[current_index].disabled:
		current_index = (current_index + 1) % items.size()

		i += 1

func next_if_disabled():
	while items[current_index].disabled:
		current_index = (current_index + 1) % items.size()

func previous():
	if items.size() <= 0:
		return

	var i := 0
	while i == 0 or items[current_index].disabled:
		# this weird maths ensures we wrap around to the bottom
		# if we're currently at the top
		current_index = (current_index + items.size() - 1) % items.size()

		i += 1

func after_visibility_changed():
	if items.size() > 0:
		current_index = clampi(current_index, 0, items.size() - 1)

	highlight_current()
