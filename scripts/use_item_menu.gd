@tool
extends ListMenu

@export
var item_consumer: ItemConsumer

@onready
var description_label: Label = %Description

@onready
var use_item: MenuItem = %Use

@onready
var use_all_item: MenuItem = %UseAll

var selected_item: Item

var player_facing_tile: Tile

# MEDIUM: assign values of this enum to the menu items, rather than mapping
# menu item indexes to these enum values
enum UseItemAction { USE, USE_ALL, DROP, DROP_ALL, NONE }

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

	update_for(selected_item)

	if description_label:
		description_label.text = stack.item.description

	var callable := enable_menu.bind()
	get_tree().process_frame.connect(callable, CONNECT_ONE_SHOT)

func _on_bag_menu_selected_item_changed(item: Item):
	selected_item = item
	update_for(selected_item)

func _on_bag_used_item(_used_item: Item, _item_stacks: Array[ItemStack]):
	update_for(selected_item)

func _on_bag_consumed_item(_consumed_item:Item, _item_stacks:Array[ItemStack]):
	update_for(selected_item)

func update_for(item: Item):
	var cannot_use := not can_use_item(item)

	use_item.disabled = cannot_use
	use_item.text = item.get_use_text() if item else "Use"

	use_all_item.disabled = cannot_use
	use_all_item.text = item.get_use_all_text() if item else "Use all"

	next_if_disabled()

func can_use_item(item: Item) -> bool:
	if not item:
		return false

	var facing_correct_tile := not item.facing_tile or (player_facing_tile.id == item.facing_tile.id)
	var can_use := item_consumer.can_use(selected_item)

	return facing_correct_tile and can_use

func _on_select_index(index: int):
	var action := get_action(index)

	match action:
		UseItemAction.USE:
			print("Using one item")
			use.emit()

		UseItemAction.USE_ALL:
			print("Using all items")
			use_all.emit()

		UseItemAction.DROP:
			print("Dropping one item")
			drop.emit()

		UseItemAction.DROP_ALL:
			print("Dropping all items")
			drop_all.emit()

func get_action(index: int) -> UseItemAction:
	match index:
		0: return UseItemAction.USE
		1: return UseItemAction.USE_ALL
		2: return UseItemAction.DROP
		3: return UseItemAction.DROP_ALL

	print("Unknown use item action " + str(index))
	return UseItemAction.NONE

func _on_cancel():
	print("Hiding UseItemMenu")

	disable_menu()

	hide()

func _on_map_player_faced_tile(tile: Tile):
	player_facing_tile = tile
