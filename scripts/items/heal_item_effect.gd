class_name HealItemEffect extends ItemEffect

@export
var heal_amount := 10

func apply_to_hit_points(hit_points: HitPoints):
    print("Healing for " + str(heal_amount) + "HP")

    hit_points.current_hp += heal_amount
