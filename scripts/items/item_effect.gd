class_name ItemEffect extends Resource

signal consume(effect: ItemEffect)

func apply():
    consume.emit(self)

func get_description():
    return "item effect"

# -------- Methods for applying the effect to various parts of the game

func can_apply_to_self(_item: Item):
    return false

func apply_to_self(_item: Item) -> ItemEffectResult:
    return null

func can_apply_to_hit_points(_hit_points: HitPoints):
    return false

func apply_to_hit_points(_hit_points: HitPoints) -> ItemEffectResult:
    return null
