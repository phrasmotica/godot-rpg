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

func get_max_index():
	return items.size() - 1

func highlight_current():
	for i in range(items.size()):
		items[i].selected = i == current_index

func select_current():
	select_index.emit(current_index)

func next_if_disabled():
	while items[current_index].disabled:
		current_index = (current_index + 1) % items.size()

func after_visibility_changed():
	if items.size() > 0:
		current_index = clampi(current_index, 0, items.size() - 1)

	highlight_current()
