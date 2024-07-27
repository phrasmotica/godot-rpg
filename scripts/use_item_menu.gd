@tool
extends ListMenu

@export
var item_consumer: ItemConsumer

@export
var description_label: Label

@export
var use_items: Array[MenuItem]

var selected_item: Item

enum PlayerFacingTile { NONE, OBSTACLE, WATER }

var player_facing_tile := PlayerFacingTile.NONE

signal use
signal use_all
signal drop
signal drop_all

func after_ready():
	disable_menu()

func _on_bag_menu_select_stack(stack: ItemStack):
	print("Showing UseItemMenu for stack ID=" + str(stack.id))

	show()

	selected_item = stack.item

	disable_items()

	if description_label:
		description_label.text = stack.item.description

	call_deferred("enable_menu")

func _on_bag_used_item(_used_item: Item, _item_stacks: Array[ItemStack]):
	disable_items()

func _on_bag_consumed_item(_consumed_item:Item, _item_stacks:Array[ItemStack]):
	disable_items()

func disable_items():
	for x in use_items:
		var should_be_facing_obstacle = selected_item.requires_facing_obstacle and player_facing_tile == PlayerFacingTile.NONE
		x.disabled = should_be_facing_obstacle or not item_consumer.can_use(selected_item)
		next_if_disabled()

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

	disable_menu()

	hide()

func _on_player_facing_obstacle():
	print("Player is facing obstacle")
	player_facing_tile = PlayerFacingTile.OBSTACLE

func _on_player_not_facing_obstacle():
	print("Player is NOT facing obstacle")
	player_facing_tile = PlayerFacingTile.NONE

func _on_player_facing_water():
	print("Player is facing water")
	player_facing_tile = PlayerFacingTile.WATER
