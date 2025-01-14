class_name NPCTradeTracker extends Node

var _tracking_npc: NPC

signal traded_item(give_item_id: int, receive_item_id: int)

func track(npc: NPC) -> void:
    print("Tracking NPC: %s" % npc.name)

    _tracking_npc = npc

    var trade := npc.get_trade()
    if trade:
        Dialogic.VAR.trade_give_item_id = trade.give_item.id

func untrack() -> void:
    print("Untracking NPC: %s" % _tracking_npc.name)

    _tracking_npc = null

    Dialogic.VAR.trade_give_item_id = -1

func handle_trade_item(item_id: int) -> void:
    var item_trade := _tracking_npc.get_trade()
    if not item_trade:
        return

    var trade_for_item_id := item_trade.receive_item.id
    item_trade.amount -= 1

    print("Trading item ID=%d for item ID=%d (%d remaining)" % [item_id, trade_for_item_id, item_trade.amount])

    traded_item.emit(item_id, trade_for_item_id)

func handle_dialogue_ended() -> void:
    if not _tracking_npc:
        return

    var timeline: String = Dialogic.VAR.resume_with_timeline

    if timeline.length() > 0:
        print("Dialogue will resume with timeline %s, continuing to track NPC: %s" % [timeline, _tracking_npc.name])
        return

    untrack()
