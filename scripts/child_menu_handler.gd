@tool
extends Node

@export
var parent_menu: Menu

@export
var child_menus: Array[Menu] = []

func _ready() -> void:
    parent_menu.steal_control.connect(_handle_parent_menu_steal_control)

    for m in child_menus:
        m.menu_hidden.connect(_handle_child_menu_hidden)
        m.menu_shown.connect(_handle_child_menu_shown)

func _handle_parent_menu_steal_control(menu: Menu) -> void:
    print(menu.name + " stole control from " + str(child_menus.size()) + " child menu(s)")

    for m in child_menus:
        m.disable_menu()
        m.hide()

func _handle_child_menu_hidden(menu: Menu) -> void:
    print(menu.name + " hidden")

    if child_menus.all(_menu_is_closed):
        parent_menu.uncover_menu()

func _handle_child_menu_shown(menu: Menu) -> void:
    print(menu.name + " shown")

    parent_menu.cover_menu()

func _menu_is_closed(menu: Menu) -> bool:
    return menu.get_menu_state() == Menu.MenuState.CLOSED
