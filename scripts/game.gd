extends Node2D

@export
var walk_mode: GUIDEMappingContext

func _ready() -> void:
	GUIDE.enable_mapping_context(walk_mode)
