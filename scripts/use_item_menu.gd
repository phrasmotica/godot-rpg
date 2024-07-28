@tool
extends ListMenu

@export
var item_consumer: ItemConsumer

@export
var description_label: Label

@export
var use_items: Array[MenuItem]

var selected_item: Item

enum TileId { NONE, OBSTACLE, WATER, SAND }

var player_facing_tile := TileId.NONE

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
	# HIGH: update the selected item before calling disable_items(); an item
	# may have just been used, put back into the bag on the same stack, and
	# not be usable anymore
	disable_items()

func _on_bag_consumed_item(_consumed_item:Item, _item_stacks:Array[ItemStack]):
	disable_items()

func disable_items():
	var requires_facing_tile_id := selected_item.requires_facing_tile_id

	for x in use_items:
		var facing_wrong_tile = requires_facing_tile_id > -1 and player_facing_tile != requires_facing_tile_id
		x.disabled = facing_wrong_tile or not item_consumer.can_use(selected_item)
		next_if_disabled()

func _on_select_index(index: int):
	# MEDIUM: this isn't great - should probably define an enum
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
	player_facing_tile = TileId.OBSTACLE

func _on_player_not_facing_obstacle():
	print("Player is NOT facing obstacle")
	player_facing_tile = TileId.NONE

func _on_map_player_faced_tile(tile_id:int):
	player_facing_tile = tile_id as TileId
