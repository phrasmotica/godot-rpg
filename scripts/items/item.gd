class_name Item extends Resource

@export
var id := -1

@export
var name := ""

@export_multiline
var description := ""

@export
var icon: Texture2D

@export
var requires_facing_obstacle := false

## A list of effects that are applied when the item is used, but do NOT
## cause the item to be consumed. If this is non-empty, one of these effects
## MUST be applied for any of the item's external effects to be applied.
@export
var use_effects: Array[ItemEffect] = []

## A list of effects that are applied when the item is used, and
## cause the item to be consumed. These will only apply if at least
## one of the item's use effects gets applied, or if the item has
## no use effects.
@export
var external_effects: Array[ItemEffect] = []

@export
var meta := {}
