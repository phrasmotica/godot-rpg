@tool
class_name PlayerStatsPanel extends Menu

enum State { DISABLED, ENABLED }

@export
var player_hit_points: HitPoints

@onready
var dimmer: Dimmer = %Dimmer

@onready
var content: Control = %Content

@onready
var hp_label: Label = %HPLabel

var _state_factory := PlayerStatsPanelStateFactory.new()
var _current_state: PlayerStatsPanelState = null

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	# TODO: make sure current HP text is refreshed here

	switch_state(State.DISABLED)

func switch_state(state: State, state_data := PlayerStatsPanelStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		dimmer,
		content,
		player_hit_points,
		hp_label)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "PlayerStatsPanelStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func disable_menu() -> void:
	switch_state(State.DISABLED)

func enable_menu() -> void:
	switch_state(State.ENABLED)
