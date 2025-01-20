@tool
class_name AppearanceMenu extends Menu

@export
var toggle_menu_input_handler: ToggleMenuInputHandler

@onready
var list_menu_behaviour: ListMenu = %ListMenuBehaviour

@onready
var list_menu_input_handler: ListMenuInputHandler = %ListMenuInputHandler

@onready
var dimmer: Dimmer = %Dimmer

@onready
var next_frame_handler: NextFrameHandler = %NextFrameHandler

@onready
var ui_updater: AppearanceMenuUIUpdater = %UIUpdater

var _is_edit_mode := false

signal show_appearance_editor
signal hide_appearance_editor

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	cancel.connect(_handle_cancel)
	visibility_changed.connect(_handle_visibility_changed)

	toggle_menu_input_handler.toggled.connect(_handle_toggle_menu)

	list_menu_input_handler.next.connect(_handle_next)
	list_menu_input_handler.previous.connect(_handle_previous)
	list_menu_input_handler.select.connect(_handle_select)

func _handle_toggle_menu() -> void:
	if menu_state_handler.can_listen():
		cancel_menu()

func _handle_next() -> void:
	list_menu_behaviour.next()
	list_menu_behaviour.next_if_disabled()

func _handle_previous() -> void:
	list_menu_behaviour.previous()
	list_menu_behaviour.previous_if_disabled()

func _handle_select() -> void:
	var item := list_menu_behaviour.item()
	if item.disabled:
		return

	_is_edit_mode = true

	ui_updater.set_edit_mode()

	show_appearance_editor.emit()

func _handle_cancel() -> void:
	# doing this on the next frame ensures the menu set cannot listen for the
	# cancel input until after this menu has returned to normal mode
	next_frame_handler.on_next_frame(
		func():
			_is_edit_mode = false
	)

	ui_updater.set_normal_mode()

	hide_appearance_editor.emit()

## Menu overrides

func is_covered() -> bool:
	return _is_edit_mode or super.is_covered()

func disable_menu() -> void:
	_dim_menu()

	ui_updater.hide_content()

func enable_menu() -> void:
	_undim_menu()

	ui_updater.show_content()

func cover_menu() -> void:
	super.cover_menu()

	_dim_menu()

func uncover_menu() -> void:
	super.uncover_menu()

	_undim_menu()

func _dim_menu() -> void:
	dimmer.is_dimmed = true
	menu_state_handler.disable()

func _undim_menu() -> void:
	dimmer.is_dimmed = false
	menu_state_handler.enable()
