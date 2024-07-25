class_name ItemConsumer extends Node

@export
var player: Player

func consume(item: Item) -> bool:
    # HIGH: verify that the item can be used

    for x in item.external_effects:
        x.apply_to_player(player)

    return true
