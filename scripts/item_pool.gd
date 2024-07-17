class_name ItemPool extends Node

@export
var items := {}

func get_random() -> Item:
	return items.values().pick_random()
