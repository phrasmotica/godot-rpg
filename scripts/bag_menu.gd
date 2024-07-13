extends Control

@export
var bag: Bag

@export
var empty_label: Label

func _ready():
	if bag:
		bag.added_item.connect(_on_bag_added_item)

func _on_bag_added_item(new_item: Item, items: Array[Item]):
	print("Added " + new_item.name + " to bag")

	var count := len(items)

	if count > 1:
		empty_label.text = "Your bag contains " + str(count) + " items."
	elif count == 1:
		empty_label.text = "Your bag contains 1 item."
	else:
		empty_label.text = "Your bag is empty."
