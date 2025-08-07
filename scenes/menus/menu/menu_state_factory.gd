class_name MenuStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		Menu.State.DISABLED: MenuStateDisabled,
		Menu.State.ENABLED: MenuStateEnabled,
		Menu.State.COVERED: MenuStateCovered,
	}

func get_fresh_state(state: Menu.State) -> MenuState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
