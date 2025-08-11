class_name NPCState
extends Node

signal state_transition_requested(new_state: NPC.State, state_data: NPCStateData)

var _npc: NPC = null
var _state_data: NPCStateData = null

func setup(
	npc: NPC,
	state_data: NPCStateData,
) -> void:
	_npc = npc
	_state_data = state_data

func transition_state(
	new_state: NPC.State,
	state_data := NPCStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)
