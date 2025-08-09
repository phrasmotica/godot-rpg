class_name UseItemMenuStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		UseItemMenu.State.DISABLED: UseItemMenuStateDisabled,
		UseItemMenu.State.ENABLED: UseItemMenuStateEnabled,
	}

func get_fresh_state(state: UseItemMenu.State) -> UseItemMenuState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
