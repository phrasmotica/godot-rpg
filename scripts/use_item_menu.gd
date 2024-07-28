@tool
extends ListMenu

@export
var item_consumer: ItemConsumer

@export
var description_label: Label

@export
var use_items: Array[MenuItem]

var selected_item: Item

var player_facing_tile: Tile

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

	disable_items(selected_item)

	if description_label:
		description_label.text = stack.item.description

	call_deferred("enable_menu")

func _on_bag_menu_selected_item_changed(item: Item):
	selected_item = item
	disable_items(selected_item)

func _on_bag_used_item(_used_item: Item, _item_stacks: Array[ItemStack]):
	disable_items(selected_item)

func _on_bag_consumed_item(_consumed_item:Item, _item_stacks:Array[ItemStack]):
	disable_items(selected_item)

func disable_items(item: Item):
	var cannot_use := not can_use_item(item)

	for x in use_items:
		x.disabled = cannot_use
		next_if_disabled()

func can_use_item(item: Item) -> bool:
	if not item:
		return false

	var facing_correct_tile := not item.facing_tile or (player_facing_tile.id == item.facing_tile.id)
	var can_use := item_consumer.can_use(selected_item)

	return facing_correct_tile and can_use

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

func _on_map_player_faced_tile(tile: Tile):
	player_facing_tile = tile
