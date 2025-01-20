@tool
class_name AppearanceMenu extends Menu

@onready
var list_menu_behaviour: ListMenu = %ListMenuBehaviour

@onready
var list_menu_input_handler: ListMenuInputHandler = %ListMenuInputHandler

@onready
var dimmer: Dimmer = %Dimmer

@onready
var ui_updater: AppearanceMenuUIUpdater = %UIUpdater

signal show_appearance_editor

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	visibility_changed.connect(_handle_visibility_changed)

	list_menu_input_handler.next.connect(_handle_next)
	list_menu_input_handler.previous.connect(_handle_previous)
	list_menu_input_handler.select.connect(_handle_select)

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

	ui_updater.set_edit_mode()

	show_appearance_editor.emit()

## Menu overrides

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
