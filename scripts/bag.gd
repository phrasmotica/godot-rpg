class_name Bag extends Node

@export
var item_pool: ItemPool

var items: Array[Item] = []

signal added_item(new_item: Item, items: Array[Item])

func _process(_delta):
	if Input.is_action_just_pressed("pick_up"):
		add_item()

func add_item():
	var new_item := item_pool.get_random()

	items.append(new_item)

	added_item.emit(new_item, items)
