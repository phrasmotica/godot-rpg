class_name PlayerStateEnabled
extends PlayerState

func _enter_tree() -> void:
	print("Player is now enabled")

	_ui_manager.menu_opened.connect(_disable)

	_player.position = _grid_movement.get_snapped_position(_player.position)

	_grid_movement.position_faced.connect(_handle_position_faced)

	_grid_movement.set_raycast_mask(_player.raycast_mask)
	_grid_movement.check_facing_tile()

	_player_interact_input_handler.interacted.connect(_handle_interacted)
	_player_interact_input_handler.dialogue_triggered.connect(_handle_dialogue_triggered)
	_player_interact_input_handler.pickup_item_triggered.connect(_handle_pickup_item_triggered)

	_player_move_input_handler.face_triggered.connect(_handle_face_triggered)
	_player_move_input_handler.move_triggered.connect(_handle_move_triggered)

	_player.moving_to_position.emit(_player.global_position)

func _disable() -> void:
	transition_state(Player.State.DISABLED)

func _handle_position_faced(pos: Vector2i) -> void:
	_player.emit_position_faced(pos)

func _handle_interacted() -> void:
	_player.emit_interacted()

func _handle_dialogue_triggered(npc: NPC) -> void:
	if npc.can_be_interacted():
		npc.face_to(_player.global_position)
		DialogueManager.start_timeline(npc.talk_dialogue)

		_player.emit_interacted()

func _handle_pickup_item_triggered(item: Item) -> void:
	_player.emit_pickup_item(item)
	_player.emit_interacted()

func _handle_face_triggered(direction: Vector2) -> void:
	_grid_movement.face(direction)

func _handle_move_triggered(direction: Vector2) -> void:
	var party_colliders := _party.get_colliders() if _party else []
	if _grid_movement.is_colliding_with(party_colliders):
		return

	var state_data := PlayerStateData.build() \
		.with_move_direction(direction)

	transition_state(Player.State.MOVING, state_data)
