extends Node

@export
var ctx_bag_menu: GUIDEMappingContext

@export
var ctx_debug_mode: GUIDEMappingContext

@export
var ctx_interact: GUIDEMappingContext

@export
var ctx_menu_nav: GUIDEMappingContext

@export
var ctx_walk_mode: GUIDEMappingContext

@export
var dialogue_manager: DialogueManager

@export
var ui_manager: UIManager

@onready
var next_frame_handler: NextFrameHandler = %NextFrameHandler

var _menu_is_open := false

func _ready() -> void:
	GUIDE.enable_mapping_context(ctx_bag_menu)
	GUIDE.enable_mapping_context(ctx_debug_mode)
	GUIDE.enable_mapping_context(ctx_interact)
	GUIDE.enable_mapping_context(ctx_walk_mode)

	if dialogue_manager:
		dialogue_manager.timeline_started.connect(_handle_dialogue_started)
		dialogue_manager.timeline_ended.connect(_handle_dialogue_finished)

	if ui_manager:
		ui_manager.menu_opened.connect(_handle_menu_opened)
		ui_manager.menu_closed.connect(_handle_menu_closed)

func _handle_dialogue_started() -> void:
	_disable_walk_mode()
	_disable_bag_menu()
	_disable_menu_nav()

func _handle_dialogue_finished() -> void:
	next_frame_handler.on_next_frame(_enable_bag_menu)

	# TODO: implement a stack of mapping contexts so that we disable/enable the
	# correct ones once the dialogue finishes? Or can we use GUIDE's priority
	# system for this?
	if _menu_is_open:
		next_frame_handler.on_next_frame(_enable_menu_nav)
	else:
		next_frame_handler.on_next_frame(_enable_walk_mode)

func _handle_menu_opened() -> void:
	_menu_is_open = true

	_disable_walk_mode()
	_enable_menu_nav()

func _handle_menu_closed() -> void:
	_menu_is_open = false

	next_frame_handler.on_next_frame(_enable_walk_mode_if_unoccupied)
	next_frame_handler.on_next_frame(_disable_menu_nav)

func _enable_walk_mode_if_unoccupied() -> void:
	# this might be called right before we immediately start a new
	# dialogue timeline, e.g. during an NPC item trade, so don't
	# re-enable walk mode yet in this scenario
	if not dialogue_manager.is_busy():
		_enable_walk_mode()

func _enable_walk_mode() -> void:
	GUIDE.enable_mapping_context(ctx_interact)
	GUIDE.enable_mapping_context(ctx_walk_mode)

func _disable_walk_mode() -> void:
	GUIDE.disable_mapping_context(ctx_interact)
	GUIDE.disable_mapping_context(ctx_walk_mode)

func _disable_bag_menu() -> void:
	GUIDE.disable_mapping_context(ctx_bag_menu)

func _enable_bag_menu() -> void:
	GUIDE.enable_mapping_context(ctx_bag_menu)

func _enable_menu_nav() -> void:
	GUIDE.enable_mapping_context(ctx_menu_nav)

func _disable_menu_nav() -> void:
	GUIDE.disable_mapping_context(ctx_menu_nav)
