class_name HealEffectResult extends ItemConsumeResult

@export
var amount: int

func process_for_dialogue():
    if dialogue_timeline:
        Dialogic.VAR.heal_amount = amount
