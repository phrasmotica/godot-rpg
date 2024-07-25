class_name ItemConsumer extends Node

@export
var hit_points: HitPoints

func can_consume(item: Item) -> bool:
    for x in item.external_effects:
        if x.can_apply_to_hit_points(hit_points):
            return true

    return false

func consume(item: Item) -> bool:
    var some_effect_applied := false

    for x in item.external_effects:
        if x.can_apply_to_hit_points(hit_points):
            x.apply_to_hit_points(hit_points)

            some_effect_applied = true
        else:
            print("Cannot apply " + x.get_description() + " to hit points")

    return some_effect_applied
