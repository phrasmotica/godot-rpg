class_name MenuSetStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		MenuSet.State.DISABLED: MenuSetStateDisabled,
		MenuSet.State.HIDDEN: MenuSetStateHidden,
		MenuSet.State.ENABLED: MenuSetStateEnabled,
	}

func get_fresh_state(state: MenuSet.State) -> MenuSetState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
