@tool
class_name AppearanceMenuUIUpdater extends Node

@export
var edit_menu_item: MenuItem

@export
var edit_mode_controls: Control

@export
var content: Control

func set_edit_mode() -> void:
    edit_menu_item.hide()
    edit_mode_controls.show()

func set_normal_mode() -> void:
    edit_menu_item.show()
    edit_mode_controls.hide()

func hide_content() -> void:
    if content:
        content.hide()

func show_content() -> void:
    if content:
        content.show()
