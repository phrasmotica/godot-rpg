extends Control

@export
var bag: Bag

@export
var item_list: VBoxContainer

@export
var empty_label: Label

@export
var item_button_scene: PackedScene

var item_buttons: Array[ItemButton]
var current_item: ItemButton

func _ready():
	if bag:
		bag.added_item.connect(_on_bag_added_item)

func _on_bag_added_item(new_item: Item, items: Array[Item]):
	print("Added " + new_item.name + " to bag")

	var count := len(items)
	empty_label.visible = count <= 0

	var new_button: ItemButton = item_button_scene.instantiate()

	new_button.text = new_item.name
	new_button.focused.connect(_on_item_button_focused)

	item_list.add_child(new_button)
	item_buttons.append(new_button)

	new_button.call_deferred("grab_focus")

func _on_item_button_focused(button: ItemButton):
	current_item = button

func _on_visibility_changed():
	if not current_item and len(item_buttons) > 0:
		current_item = item_buttons[0]

	if current_item:
		current_item.grab_focus()
