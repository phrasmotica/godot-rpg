class_name ItemConsumer extends Node

@export
var hit_points: HitPoints

func consume(item: Item) -> bool:
    # HIGH: verify that the item can be used

    for x in item.external_effects:
        x.apply_to_hit_points(hit_points)

    return true
