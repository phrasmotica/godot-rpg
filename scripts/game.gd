extends Node2D

@export
var ctx_interact: GUIDEMappingContext

@export
var walk_mode: GUIDEMappingContext

@export
var dialogue_manager: DialogueManager

func _ready() -> void:
	GUIDE.enable_mapping_context(ctx_interact)
	GUIDE.enable_mapping_context(walk_mode)

	if dialogue_manager:
		dialogue_manager.timeline_started.connect(handle_dialogue_started)
		dialogue_manager.timeline_ended.connect(handle_dialogue_finished)

func handle_dialogue_started():
	disable_walk_mode()

func handle_dialogue_finished():
	get_tree().process_frame.connect(enable_walk_mode, CONNECT_ONE_SHOT)

func enable_walk_mode() -> void:
	GUIDE.enable_mapping_context(ctx_interact)
	GUIDE.enable_mapping_context(walk_mode)

func disable_walk_mode() -> void:
	GUIDE.disable_mapping_context(ctx_interact)
	GUIDE.disable_mapping_context(walk_mode)
