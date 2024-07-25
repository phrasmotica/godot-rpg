class_name HealItemEffect extends ItemEffect

@export
var hp_amount := 5

func apply_to_player(_player: Player):
    print("Healing the player for " + str(hp_amount) + "HP")
