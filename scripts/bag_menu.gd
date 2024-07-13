extends Control

@export
var bag: Bag

@export
var item_list: VBoxContainer

@export
var empty_label: Label

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

	item_list.add_child(new_button)

	new_button.call_deferred("grab_focus")
