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
var requires_facing_tile_id := -1:
    set(value):
        # HIGH: move tile IDs into a global enum. Also create a resource type
        # for tile data, and save a resource for each type of tile. Put these
        # resources in the tile map's custom data layer
        requires_facing_tile_id = clamp(value, -1, 3)

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
    if meta.has("is_filled") and meta["is_filled"] == true:
        return name + " (filled)"

    return name

func same_meta_as(other: Item):
    if meta.size() == 0 and other.meta.size() == 0:
        return true

    if meta["is_filled"] != other.meta["is_filled"]:
        return false

    return true
