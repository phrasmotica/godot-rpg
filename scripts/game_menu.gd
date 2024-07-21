@tool
extends Control

enum MenuFocus { BAG, PLAYER_STATS }

@export
var player_stats_dimmer: Dimmer

@export
var bag_menu_dimmer: Dimmer

@export
var menu_focus := MenuFocus.BAG:
	set(value):
		menu_focus = value

		print("Menu focus " + str(menu_focus))

		player_stats_dimmer.is_dimmed = menu_focus == MenuFocus.BAG
		bag_menu_dimmer.is_dimmed = menu_focus == MenuFocus.PLAYER_STATS

signal menu_closed

func _ready():
	set_process(visible)

func _process(_delta):
	if Engine.is_editor_hint():
		return

	if Input.is_action_just_pressed("game_menu_cycle"):
		menu_focus = ((menu_focus + 1) % MenuFocus.size()) as MenuFocus
