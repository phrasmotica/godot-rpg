class_name PlayerState
extends Node

signal state_transition_requested(new_state: Player.State, state_data: PlayerStateData)

# TODO: create PlayerAppearance and PlayerInteraction abstractions

var _player: Player = null
var _state_data: PlayerStateData = null
var _party: Party = null
var _grid_movement: GridMovement = null
var _sprite: AnimatedSprite2D = null
var _player_interact_input_handler: PlayerInteractInputHandler = null
var _player_move_input_handler: PlayerMoveInputHandler = null

func setup(
	player: Player,
	state_data: PlayerStateData,
	party: Party,
	grid_movement: GridMovement,
	sprite: AnimatedSprite2D,
	player_interact_input_handler: PlayerInteractInputHandler,
	player_move_input_handler: PlayerMoveInputHandler,
) -> void:
	_player = player
	_state_data = state_data
	_party = party
	_grid_movement = grid_movement
	_sprite = sprite
	_player_interact_input_handler = player_interact_input_handler
	_player_move_input_handler = player_move_input_handler

func transition_state(
	new_state: Player.State,
	state_data := PlayerStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)
