class_name Bag extends Node

var items: Array[Item] = []

signal added_item(new_item: Item, items: Array[Item])

func _process(_delta):
    if Input.is_action_just_pressed("pick_up"):
        add_item()

func add_item():
    var new_item := Item.new()
    new_item.name = "Item " + str(len(items))
    new_item.description = "Item " + str(len(items))

    items.append(new_item)

    added_item.emit(new_item, items)
