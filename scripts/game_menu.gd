@tool
extends Menu

enum MenuFocus { BAG, PLAYER_STATS }

@export
var player_stats_dimmer: Dimmer

@export
var bag_menu: Menu

@export
var bag_menu_dimmer: Dimmer

@export
var menu_focus := MenuFocus.BAG:
	set(value):
		menu_focus = value

		print("Menu focus " + str(menu_focus))

		player_stats_dimmer.is_dimmed = menu_focus == MenuFocus.BAG
		bag_menu_dimmer.is_dimmed = menu_focus == MenuFocus.PLAYER_STATS

func after_ready():
	bag_menu.menu_disabled.connect(handle_bag_menu_disabled)
	bag_menu.menu_enabled.connect(handle_bag_menu_enabled)

func listen_for_inputs():
	if Input.is_action_just_pressed("menu_set_cycle_next"):
		menu_focus = ((menu_focus + 1) % MenuFocus.size()) as MenuFocus

	if Input.is_action_just_pressed("menu_set_cycle_previous"):
		menu_focus = ((menu_focus + MenuFocus.size() - 1) % MenuFocus.size()) as MenuFocus

func _on_visibility_changed():
	set_process(visible)

func handle_bag_menu_disabled(_menu: Menu):
	print("BagMenu disabled, disabling GameMenu")

	set_process(false)

	bag_menu_dimmer.is_dimmed = true

func handle_bag_menu_enabled(_menu: Menu):
	print("BagMenu enabled, enabling GameMenu")

	set_process(true)

	bag_menu_dimmer.is_dimmed = false
