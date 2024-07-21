@tool
extends Node

@export
var parent_menu: Menu

@export
var child_menus: Array[Menu] = []

func _ready():
    for m in child_menus:
        m.menu_hidden.connect(handle_child_menu_hidden)
        m.menu_shown.connect(handle_child_menu_shown)

        m.menu_disabled.connect(handle_child_menu_disabled)
        m.menu_enabled.connect(handle_child_menu_enabled)

func handle_child_menu_hidden(menu: Menu):
    print(menu.name + " hidden, what should happen to " + parent_menu.name)

    if child_menus.all(func(m: Menu): return not m.visible):
        parent_menu.enable_menu()

func handle_child_menu_shown(menu: Menu):
    print(menu.name + " shown, what should happen to " + parent_menu.name)

    parent_menu.disable_menu()

func handle_child_menu_disabled(menu: Menu):
    print(menu.name + " disabled, what should happen to " + parent_menu.name)

func handle_child_menu_enabled(menu: Menu):
    print(menu.name + " enabled, what should happen to " + parent_menu.name)
