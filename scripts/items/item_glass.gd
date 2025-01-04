class_name Glass extends Item

func get_display_name() -> String:
    if meta.has("is_filled") and meta["is_filled"] == true:
        return "Glass (filled)"

    return "Glass"

func get_description() -> String:
    if meta.has("is_filled") and meta["is_filled"] == true:
        return "Don't gulp it all down at once."

    return "Use while facing water to fill it."

func get_use_text() -> String:
    if meta.has("is_filled") and meta["is_filled"] == false:
        return "Fill"

    return "Use"

func get_use_all_text() -> String:
    if meta.has("is_filled") and meta["is_filled"] == false:
        return "Fill all"

    return "Use all"
