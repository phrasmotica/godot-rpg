class_name FillGlassItemEffect extends ItemEffect

func get_description():
    return "fills an item, such as a Glass"

func can_apply_to_self(item: Item):
    return item.meta.has("is_filled") and not item.meta["is_filled"]

func apply_to_self(item: Item):
    if item.meta.has("is_filled"):
        print("Filling " + item.name)
        item.meta["is_filled"] = true
