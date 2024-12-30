extends Node

@export
var ctx_bag_menu: GUIDEMappingContext

@export
var ctx_interact: GUIDEMappingContext

@export
var walk_mode: GUIDEMappingContext

@export
var dialogue_manager: DialogueManager

@export
var ui_manager: UIManager

func _ready() -> void:
	GUIDE.enable_mapping_context(ctx_bag_menu)
	GUIDE.enable_mapping_context(ctx_interact)
	GUIDE.enable_mapping_context(walk_mode)

	if dialogue_manager:
		dialogue_manager.timeline_started.connect(handle_dialogue_started)
		dialogue_manager.timeline_ended.connect(handle_dialogue_finished)

	if ui_manager:
		ui_manager.menu_opened.connect(handle_menu_opened)
		ui_manager.menu_closed.connect(handle_menu_closed)

func handle_dialogue_started() -> void:
	disable_walk_mode()
	disable_bag_menu()

func handle_dialogue_finished() -> void:
	on_next_frame(enable_walk_mode)
	on_next_frame(enable_bag_menu)

func handle_menu_opened() -> void:
	disable_walk_mode()

func handle_menu_closed() -> void:
	on_next_frame(enable_walk_mode)

func on_next_frame(callable: Callable) -> void:
	get_tree().process_frame.connect(callable, CONNECT_ONE_SHOT)

func enable_walk_mode() -> void:
	GUIDE.enable_mapping_context(ctx_interact)
	GUIDE.enable_mapping_context(walk_mode)

func disable_walk_mode() -> void:
	GUIDE.disable_mapping_context(ctx_interact)
	GUIDE.disable_mapping_context(walk_mode)

func disable_bag_menu() -> void:
	GUIDE.disable_mapping_context(ctx_bag_menu)

func enable_bag_menu() -> void:
	GUIDE.enable_mapping_context(ctx_bag_menu)
