class_name PlayerStatsPanelStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		PlayerStatsPanel.State.DISABLED: PlayerStatsPanelStateDisabled,
		PlayerStatsPanel.State.ENABLED: PlayerStatsPanelStateEnabled,
	}

func get_fresh_state(state: PlayerStatsPanel.State) -> PlayerStatsPanelState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
