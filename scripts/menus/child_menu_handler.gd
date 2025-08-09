@tool
class_name ChildMenuHandler extends Node

@export_group("Dependencies")

@export
var dialogue_manager: DialogueManager

@export
var parent_menu: Menu

@export
var child_menus: Array[Menu] = []

func _ready() -> void:
    parent_menu.steal_control.connect(_handle_parent_menu_steal_control)

    for m in child_menus:
        m.menu_hidden.connect(_handle_child_menu_hidden)
        m.menu_shown.connect(_handle_child_menu_shown)

        if dialogue_manager:
            dialogue_manager.timeline_started.connect(m.cover)
            dialogue_manager.timeline_ended.connect(m.uncover)

func _handle_parent_menu_steal_control(menu: Menu) -> void:
    print(menu.name + " stole control from " + str(child_menus.size()) + " child menu(s)")

    for m in child_menus:
        m.disable()
        m.hide()

func _handle_child_menu_hidden(menu: Menu) -> void:
    print(menu.name + " hidden")

    if child_menus.all(_menu_is_closed):
        parent_menu.uncover()

func _handle_child_menu_shown(menu: Menu) -> void:
    print(menu.name + " shown")

    parent_menu.cover()

func _menu_is_closed(menu: Menu) -> bool:
    return menu.is_closed()

func any_menu_is_open() -> bool:
    return not child_menus.all(_menu_is_closed)
