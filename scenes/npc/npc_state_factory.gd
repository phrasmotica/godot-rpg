class_name NPCStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		NPC.State.ENABLED: NPCStateEnabled,
	}

func get_fresh_state(state: NPC.State) -> NPCState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
