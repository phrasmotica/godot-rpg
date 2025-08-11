class_name HealEffectResult extends ItemConsumeResult

var _amount: int

func _init(amount: int) -> void:
	_amount = amount

func process_for_dialogue() -> void:
	Dialogic.VAR.heal_amount = _amount
	DialogueManager.start_timeline("healed_amount")
