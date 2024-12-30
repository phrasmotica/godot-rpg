extends Node2D

@export
var ctx_interact: GUIDEMappingContext

@export
var walk_mode: GUIDEMappingContext

func _ready() -> void:
	GUIDE.enable_mapping_context(ctx_interact)
	GUIDE.enable_mapping_context(walk_mode)
