class_name NPCTradeTracker extends Node

var _tracking_npc: NPC

func track(npc: NPC) -> void:
    print("Tracking NPC: %s" % npc.name)

    _tracking_npc = npc

func handle_dialogue_ended() -> void:
    if not _tracking_npc:
        return

    var timeline: String = Dialogic.VAR.resume_with_timeline

    if timeline.length() > 0:
        print("Dialogue will resume with timeline %s, continuing to track NPC: %s" % [timeline, _tracking_npc.name])
    else:
        print("Dialogue ended, untracking NPC: %s" % _tracking_npc.name)

        _tracking_npc = null
