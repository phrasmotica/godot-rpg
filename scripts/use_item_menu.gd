@tool
extends Menu

@export
var description_label: Label

@export
var use_items: Array[MenuItem]

var selected_item: Item

var player_facing_obstacle := false

signal use
signal use_all
signal drop
signal drop_all

func _on_bag_menu_select_stack(stack: ItemStack):
	print("Showing UseItemMenu for stack ID=" + str(stack.id))

	show()

	selected_item = stack.item

	for x in use_items:
		x.disabled = not player_facing_obstacle

	if description_label:
		description_label.text = stack.item.description

func _on_select_index(index: int):
	# TODO: this isn't great - should probably define an enum
	# for the actions that this menu contains
	match index:
		0:
			print("Using one item")
			use.emit()

		1:
			print("Using all items")
			use_all.emit()

		2:
			print("Dropping one item")
			drop.emit()

		3:
			print("Dropping all items")
			drop_all.emit()

func _on_cancel():
	print("Hiding UseItemMenu")

	hide()

func _on_player_facing_obstacle():
	print("Player is facing obstacle")
	player_facing_obstacle = true

func _on_player_not_facing_obstacle():
	print("Player is NOT facing obstacle")
	player_facing_obstacle = false
