class_name DialogicSignalEventHandler extends Node

signal choose_item_from_bag

func handle(argument: String) -> void:
    if argument == "choose_item_from_bag":
        choose_item_from_bag.emit()
