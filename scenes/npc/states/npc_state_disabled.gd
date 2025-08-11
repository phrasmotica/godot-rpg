class_name NPCStateDisabled
extends NPCState

func _enter_tree() -> void:
	print("%s is now disabled" % _npc.name)

	_move_timer.stop()
