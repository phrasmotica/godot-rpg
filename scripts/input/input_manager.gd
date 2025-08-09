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
var ctx_outfit_nav: GUIDEMappingContext

@export
var ctx_walk_mode: GUIDEMappingContext

@export
var ui_manager: UIManager

var _menu_is_open := false

# TODO: create a state machine for the Player. It'll reduce the need to toggle
# the mapping contexts

func _ready() -> void:
	GUIDE.enable_mapping_context(ctx_bag_menu)
	GUIDE.enable_mapping_context(ctx_debug_mode)
	GUIDE.enable_mapping_context(ctx_interact)
	GUIDE.enable_mapping_context(ctx_walk_mode)

	AppearanceMenuEvents.editing_started.connect(_handle_show_appearance_editor)
	AppearanceMenuEvents.editing_finished.connect(_handle_hide_appearance_editor)

	DialogueManager.timeline_started.connect(handle_dialogue_started)
	DialogueManager.timeline_ended.connect(handle_dialogue_finished)

	if ui_manager:
		ui_manager.menu_opened.connect(handle_menu_opened)
		ui_manager.menu_closed.connect(handle_menu_closed)

func _handle_show_appearance_editor() -> void:
	disable_menu_nav()
	enable_outfit_nav()

func _handle_hide_appearance_editor() -> void:
	enable_menu_nav()
	disable_outfit_nav()

func handle_dialogue_started() -> void:
	disable_walk_mode()
	disable_bag_menu()
	disable_menu_nav()

func handle_dialogue_finished() -> void:
	SignalHelper.once_next_frame(enable_bag_menu)

	# TODO: implement a stack of mapping contexts so that we disable/enable the
	# correct ones once the dialogue finishes? Or can we use GUIDE's priority
	# system for this?
	if _menu_is_open:
		SignalHelper.once_next_frame(enable_menu_nav)
	else:
		SignalHelper.once_next_frame(enable_walk_mode)

func handle_menu_opened() -> void:
	_menu_is_open = true

	disable_walk_mode()
	enable_menu_nav()

func handle_menu_closed() -> void:
	_menu_is_open = false

	SignalHelper.once_next_frame(enable_walk_mode)
	SignalHelper.once_next_frame(disable_menu_nav)

func enable_walk_mode() -> void:
	GUIDE.enable_mapping_context(ctx_interact)
	GUIDE.enable_mapping_context(ctx_walk_mode)

func disable_walk_mode() -> void:
	GUIDE.disable_mapping_context(ctx_interact)
	GUIDE.disable_mapping_context(ctx_walk_mode)

func disable_bag_menu() -> void:
	GUIDE.disable_mapping_context(ctx_bag_menu)

func enable_bag_menu() -> void:
	GUIDE.enable_mapping_context(ctx_bag_menu)

func enable_menu_nav() -> void:
	GUIDE.enable_mapping_context(ctx_menu_nav)

func disable_menu_nav() -> void:
	GUIDE.disable_mapping_context(ctx_menu_nav)

func enable_outfit_nav() -> void:
	GUIDE.enable_mapping_context(ctx_outfit_nav)

func disable_outfit_nav() -> void:
	GUIDE.disable_mapping_context(ctx_outfit_nav)
