class_name NPCTradeTracker extends Node

var _tracking_npc: NPC

func track(npc: NPC) -> void:
    print("Tracking NPC: %s" % npc.name)

    _tracking_npc = npc
