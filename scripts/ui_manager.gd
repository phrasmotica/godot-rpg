extends Node

@export
var bag_menu: Control

func _process(_delta):
	if Input.is_action_just_pressed("toggle_bag"):
		bag_menu.visible = not bag_menu.visible

func _on_bag_added_item(item: Item):
	print("Added " + item.name + " to bag")
