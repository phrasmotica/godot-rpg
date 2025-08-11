class_name PlayerStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		Player.State.DISABLED: PlayerStateDisabled,
		Player.State.ENABLED: PlayerStateEnabled,
		Player.State.MOVING: PlayerStateMoving,
	}

func get_fresh_state(state: Player.State) -> PlayerState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
