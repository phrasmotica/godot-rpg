class_name NPCStateEnabled
extends NPCState

func _enter_tree() -> void:
	print("%s is now enabled" % _npc.name)
