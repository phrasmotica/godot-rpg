class_name PlayerInteractInputHandler extends Node

@export
var grid_movement: GridMovement

@export
var interact: GUIDEAction

signal dialogue_triggered(npc: NPC)
signal pickup_item_triggered(item: Item)

func _ready():
	interact.triggered.connect(_handle_interact_triggered)

func _handle_interact_triggered() -> void:
	var collider = grid_movement.raycast.get_collider()

	if not collider:
		return

	if collider is NPC:
		var npc := collider as NPC

		dialogue_triggered.emit(npc)

	elif collider is ItemArea:
		var item_area = collider as ItemArea
		var item := item_area.get_item()
		item_area.dispose()

		pickup_item_triggered.emit(item)
