class_name Glass extends Item

func get_display_name() -> String:
    if _is_filled():
        return "Glass (filled)"

    return "Glass"

func get_description() -> String:
    if _is_filled():
        return "Don't gulp it all down at once."

    return "Use while facing water to fill it."

func get_use_text() -> String:
    if not _is_filled():
        return "Fill"

    return "Use"

func get_use_all_text() -> String:
    if not _is_filled():
        return "Fill all"

    return "Use all"

func get_required_facing_tile() -> Tile:
    if _is_filled():
        return null

    return facing_tile

func _is_filled() -> bool:
    return meta.has("is_filled") and meta["is_filled"] == true
