class_name ItemArea extends Area2D

@export
var pickup: ItemPickup

func get_item() -> Item:
	return pickup.item

func dispose():
	pickup.queue_free()
