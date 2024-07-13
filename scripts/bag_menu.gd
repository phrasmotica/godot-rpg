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

	var new_label := Label.new()
	new_label.text = new_item.name

	item_list.add_child(new_label)
