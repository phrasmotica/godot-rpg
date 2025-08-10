class_name PlayerState
extends Node

signal state_transition_requested(new_state: Player.State, state_data: PlayerStateData)

var _player: Player = null
var _state_data: PlayerStateData = null

func setup(
	player: Player,
	state_data: PlayerStateData,
) -> void:
	_player = player
	_state_data = state_data

func transition_state(
	new_state: Player.State,
	state_data := PlayerStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)
