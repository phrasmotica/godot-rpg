@tool
extends Node

@export
var parent_menu: Menu

@export
var child_menus: Array[Menu] = []

func _ready():
    parent_menu.steal_control.connect(
        func(menu: Menu):
            print(menu.name + " stole control, hiding " + str(child_menus.size()) + " child menu(s)")

            for m in child_menus:
                m.disable_menu()
                m.hide()
    )

    for m in child_menus:
        m.menu_hidden.connect(handle_child_menu_hidden)
        m.menu_shown.connect(handle_child_menu_shown)

        m.menu_disabled.connect(handle_child_menu_disabled)
        m.menu_enabled.connect(handle_child_menu_enabled)

func handle_child_menu_hidden(menu: Menu):
    print(menu.name + " hidden")

    if child_menus.all(func(m: Menu): return not m.visible):
        parent_menu.enable_menu()

func handle_child_menu_shown(menu: Menu):
    print(menu.name + " shown")

    parent_menu.disable_menu()

func handle_child_menu_disabled(menu: Menu):
    print(menu.name + " disabled")

func handle_child_menu_enabled(menu: Menu):
    print(menu.name + " enabled")
