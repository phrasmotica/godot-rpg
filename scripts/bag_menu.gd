extends Control

@export
var bag: Bag

@export
var item_list: VBoxContainer

@export
var empty_label: Label

var item_buttons: Array[Control]
var current_item: Control

func _ready():
	if bag:
		bag.added_item.connect(_on_bag_added_item)

func _on_bag_added_item(new_item: Item, items: Array[Item]):
	print("Added " + new_item.name + " to bag")

	var count := len(items)
	empty_label.visible = count <= 0

	var new_button := Button.new()
	new_button.text = new_item.name
	new_button.alignment = HORIZONTAL_ALIGNMENT_LEFT

	new_button.focus_entered.connect(
		func():
			current_item = new_button
	)

	item_list.add_child(new_button)
	item_buttons.append(new_button)

	new_button.call_deferred("grab_focus")

func _on_visibility_changed():
	if not current_item and len(item_buttons) > 0:
		current_item = item_buttons[0]

	if current_item:
		current_item.grab_focus()
