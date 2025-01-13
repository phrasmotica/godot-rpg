class_name NPCTradeTracker extends Node

var _tracking_npc: NPC

func track(npc: NPC) -> void:
    print("Tracking NPC: %s" % npc.name)

    _tracking_npc = npc

func handle_trade_item(item_id: int) -> void:
    if not _tracking_npc or not _tracking_npc.npc_data or not _tracking_npc.npc_data.item_trade:
        return

    var trade_for_item_id := _tracking_npc.npc_data.item_trade.receive_item.id

    print("Trading item ID=%d for item ID=%d" % [item_id, trade_for_item_id])

    # HIGH: emit a signal that the bag can connect to, which removes the traded
    # item from and adds the received item to the player's bag

func handle_dialogue_ended() -> void:
    if not _tracking_npc:
        return

    var timeline: String = Dialogic.VAR.resume_with_timeline

    if timeline.length() > 0:
        print("Dialogue will resume with timeline %s, continuing to track NPC: %s" % [timeline, _tracking_npc.name])
    else:
        print("Dialogue ended, untracking NPC: %s" % _tracking_npc.name)

        _tracking_npc = null
