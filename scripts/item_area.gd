class_name ItemArea extends Area2D

@export
var pickup: ItemPickup

signal player_is_looking

func player_looking():
	player_is_looking.emit()

func get_item_id() -> int:
	return pickup.item.id
