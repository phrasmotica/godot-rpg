extends Node2D

@export
var player: Player

@onready
var trade_tracker: NPCTradeTracker = %TradeTracker

func _ready() -> void:
	if player:
		player.dialogue_triggered.connect(trade_tracker.track)
