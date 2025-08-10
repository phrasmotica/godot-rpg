class_name PlayerStateEnabled
extends PlayerState

func _enter_tree() -> void:
	print("Player is now enabled")

	# TODO: transition to DISABLED when the root menu set is enabled

	_player.position = _grid_movement.get_snapped_position(_player.position)

	_grid_movement.position_faced.connect(_player.emit_position_faced)
	_grid_movement.moving_started.connect(_player.emit_moving_to_position)
	_grid_movement.moving_finished.connect(_handle_grid_movement_moving_finished)

	_grid_movement.set_raycast_mask(_player.raycast_mask)
	_grid_movement.check_facing_tile()

	_player_interact_input_handler.interacted.connect(_player.emit_interacted)
	_player_interact_input_handler.dialogue_triggered.connect(_handle_dialogue_triggered)
	_player_interact_input_handler.pickup_item_triggered.connect(_handle_pickup_item_triggered)

	_player_move_input_handler.move_triggered.connect(_handle_move_triggered)

	_player.moving_to_position.emit(_player.global_position)

func _handle_grid_movement_moving_finished(pos: Vector2):
	_sprite.stop()
	_player.emit_moved_to_position(pos)

func _handle_dialogue_triggered(npc: NPC) -> void:
	npc.face(_player.global_position)
	DialogueManager.start_timeline(npc.talk_dialogue)

	_player.emit_interacted()

func _handle_pickup_item_triggered(item: Item) -> void:
	_player.emit_pickup_item(item)
	_player.emit_interacted()

func _handle_move_triggered(direction: Vector2):
	var party_colliders := _party.get_colliders() if _party else []
	_grid_movement.move_ignore_collision_set(direction, party_colliders)
