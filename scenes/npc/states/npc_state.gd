class_name NPCState
extends Node

signal state_transition_requested(new_state: NPC.State, state_data: NPCStateData)

var _npc: NPC = null
var _state_data: NPCStateData = null
var _grid_movement: GridMovement = null
var _move_timer: Timer = null

func setup(
	npc: NPC,
	state_data: NPCStateData,
	grid_movement: GridMovement,
	move_timer: Timer,
) -> void:
	_npc = npc
	_state_data = state_data
	_grid_movement = grid_movement
	_move_timer = move_timer

func transition_state(
	new_state: NPC.State,
	state_data := NPCStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

func is_interactable() -> bool:
	return false

func face_to(_pos: Vector2) -> void:
	pass
