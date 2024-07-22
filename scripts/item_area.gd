class_name ItemArea extends Area2D

@export
var pickup: ItemPickup

func get_item_id() -> int:
	return pickup.item.id

func dispose():
	pickup.queue_free()
