class_name AppearanceMenuStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		AppearanceMenu.State.DISABLED: AppearanceMenuStateDisabled,
		AppearanceMenu.State.ENABLED: AppearanceMenuStateEnabled,
		AppearanceMenu.State.EDITING: AppearanceMenuStateEditing,
	}

func get_fresh_state(state: AppearanceMenu.State) -> AppearanceMenuState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
