class_name BagMenuStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		BagMenu.State.DISABLED: BagMenuStateDisabled,
		BagMenu.State.ENABLED: BagMenuStateEnabled,
		BagMenu.State.COVERED: BagMenuStateCovered,
	}

func get_fresh_state(state: BagMenu.State) -> BagMenuState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
