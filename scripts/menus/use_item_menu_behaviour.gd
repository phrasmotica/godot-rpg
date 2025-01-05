class_name UseItemMenuBehaviour extends Node

# MEDIUM: assign values of this enum to the menu items, rather than mapping
# menu item indexes to these enum values
enum UseItemAction { USE, USE_ALL, DROP, DROP_ALL, NONE }

var _player_facing_tile: Tile

signal use
signal use_all
signal drop
signal drop_all

func can_use_item(item: Item) -> bool:
	var facing_tile := item.get_required_facing_tile()
	var facing_correct_tile := not facing_tile or (_player_facing_tile.id == facing_tile.id)

	return facing_correct_tile

func handle_player_faced_tile(tile: Tile) -> void:
	_player_facing_tile = tile

func handle_select_index(index: int):
	var action := _get_action(index)

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

func _get_action(index: int) -> UseItemAction:
	match index:
		0: return UseItemAction.USE
		1: return UseItemAction.USE_ALL
		2: return UseItemAction.DROP
		3: return UseItemAction.DROP_ALL

	print("Unknown use item action " + str(index))
	return UseItemAction.NONE
