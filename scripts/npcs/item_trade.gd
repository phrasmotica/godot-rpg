class_name ItemTrade extends Resource

@export
var talk_dialogue: String

@export
var give_item: Item

@export
var receive_item: Item

@export
var amount: int

func is_pending() -> bool:
    return amount > 0
