class_name ItemEffect extends Resource

@export
var new_external_effects: Array[ItemEffect]

signal consume(effect: ItemEffect)

func apply() -> void:
	consume.emit(self)

func get_description() -> String:
	return "item effect"

# -------- Methods for applying the effect to various parts of the game

func can_apply_to_self(_item: Item) -> bool:
	return false

func apply_to_self(_item: Item) -> ItemEffectResult:
	return null

func can_apply_to_hit_points(_hit_points: HitPoints) -> bool:
	return false

func apply_to_hit_points(_hit_points: HitPoints) -> ItemConsumeResult:
	return null
