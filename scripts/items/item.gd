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
var facing_tile: Tile

## A list of UI transitions to dispatch when the item is used.
@export
var consume_transitions: Array[UITransitionParams] = []

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

func get_display_name() -> String:
    return name

func get_description() -> String:
    return description

func get_use_text() -> String:
    return "Use"

func get_use_all_text() -> String:
    return "Use all"

func get_required_facing_tile() -> Tile:
    return facing_tile

func after_apply(applied_effect: ItemEffect) -> void:
    print("Removing use effect '%s' from %s" % [applied_effect.get_description(), name])
    use_effects.erase(applied_effect)

    print("Adding %d new external effect(s)" % applied_effect.new_external_effects.size())
    external_effects.append_array(applied_effect.new_external_effects)

    print("There are now %d external effect(s)" % external_effects.size())

func same_meta_as(other: Item):
    if meta.size() == 0 and other.meta.size() == 0:
        return true

    if meta["is_filled"] != other.meta["is_filled"]:
        return false

    return true
