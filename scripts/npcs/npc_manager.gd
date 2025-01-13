extends Node2D

@export
var player: Player

@export
var dialogue_manager: DialogueManager

@onready
var trade_tracker: NPCTradeTracker = %TradeTracker

func _ready() -> void:
	if player:
		player.dialogue_triggered.connect(trade_tracker.track)

	if dialogue_manager:
		dialogue_manager.trade_item.connect(trade_tracker.handle_trade_item)
		dialogue_manager.timeline_ended.connect(trade_tracker.handle_dialogue_ended)
