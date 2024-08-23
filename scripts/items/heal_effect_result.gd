# TODO: make this inherit something other than ItemEffectResult? The healing
# isn't being done to the item...
class_name HealEffectResult extends ItemEffectResult

@export
var amount: int

func process_for_dialogue():
    if dialogue_timeline:
        Dialogic.VAR.heal_amount = amount
