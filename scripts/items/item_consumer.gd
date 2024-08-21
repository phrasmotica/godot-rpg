class_name ItemConsumer extends Node

@export
var hit_points: HitPoints

signal item_effect_result_created(result: ItemEffectResult)

func can_use(item: Item) -> bool:
	if item.use_effects.size() <= 0 and item.external_effects.size() > 0:
		return true

	for x in item.use_effects:
		if x.can_apply_to_self(item):
			return true

	return false

func use(item: Item) -> bool:
	if item.use_effects.size() <= 0:
		return true

	var some_effect_applied := false

	for x in item.use_effects:
		if x.can_apply_to_self(item):
			var result: ItemEffectResult = x.apply_to_self(item)
			if result:
				some_effect_applied = true
				item_effect_result_created.emit(result)
		else:
			print("Cannot apply " + x.get_description() + " to self")

	return some_effect_applied

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
