class_name DialogicSignalEventHandler extends Node

signal choose_item_from_bag
signal trade_item(item_id: int)
signal trade_finished

func handle(argument: String) -> void:
    if argument == "choose_item_from_bag":
        choose_item_from_bag.emit()

    if argument == "trade_chosen_item":
        var chosen_item_id: int = Dialogic.VAR.chosen_item_id
        trade_item.emit(chosen_item_id)

    if argument == "trade_finished":
        trade_finished.emit()
