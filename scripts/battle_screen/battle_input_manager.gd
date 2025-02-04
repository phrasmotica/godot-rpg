extends Node

@export
var ctx_debug_mode: GUIDEMappingContext

@export
var ctx_menu_nav: GUIDEMappingContext

@export
var dialogue_manager: DialogueManager

@onready
var next_frame_handler: NextFrameHandler = %NextFrameHandler

func _ready() -> void:
	GUIDE.enable_mapping_context(ctx_debug_mode)
	GUIDE.enable_mapping_context(ctx_menu_nav)

	if dialogue_manager:
		dialogue_manager.timeline_started.connect(handle_dialogue_started)
		dialogue_manager.timeline_ended.connect(handle_dialogue_finished)

func handle_dialogue_started() -> void:
	disable_menu_nav()

func handle_dialogue_finished() -> void:
	next_frame_handler.on_next_frame(enable_menu_nav)

func enable_menu_nav() -> void:
	GUIDE.enable_mapping_context(ctx_menu_nav)

func disable_menu_nav() -> void:
	GUIDE.disable_mapping_context(ctx_menu_nav)
