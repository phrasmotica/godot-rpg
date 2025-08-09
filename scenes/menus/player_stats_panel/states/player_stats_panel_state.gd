class_name PlayerStatsPanelState
extends Node

signal state_transition_requested(new_state: PlayerStatsPanel.State, state_data: PlayerStatsPanelStateData)

var _menu: PlayerStatsPanel = null
var _state_data: PlayerStatsPanelStateData = null
var _dimmer: Dimmer = null
var _content: Control = null
var _player_hit_points: HitPoints = null
var _hp_label: Label = null

func setup(
	menu_set: PlayerStatsPanel,
	state_data: PlayerStatsPanelStateData,
	dimmer: Dimmer,
	content: Control,
	player_hit_points: HitPoints,
	hp_label: Label,
) -> void:
	_menu = menu_set
	_state_data = state_data
	_dimmer = dimmer
	_content = content
	_player_hit_points = player_hit_points
	_hp_label = hp_label

func transition_state(
	new_state: PlayerStatsPanel.State,
	state_data := PlayerStatsPanelStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

func _connect_signals() -> void:
	if _player_hit_points:
		_player_hit_points.current_hp_changed.connect(_handle_current_hp_changed)

func _handle_current_hp_changed(hp: int, max_hp: int) -> void:
	_hp_label.text = "%d/%d HP" % [hp, max_hp]
