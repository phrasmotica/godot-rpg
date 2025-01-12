class_name DialogicSignalEventHandler extends Node

signal choose_item_from_bag
signal trade_finished

func handle(argument: String) -> void:
    if argument == "choose_item_from_bag":
        choose_item_from_bag.emit()

    if argument == "trade_finished":
        trade_finished.emit()
