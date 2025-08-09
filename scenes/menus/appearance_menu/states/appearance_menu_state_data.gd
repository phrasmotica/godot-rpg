class_name AppearanceMenuStateData

var _visibility_changed := false

static func build() -> AppearanceMenuStateData:
	return AppearanceMenuStateData.new()

func with_visibility_changed(visibility_changed: bool) -> AppearanceMenuStateData:
	_visibility_changed = visibility_changed
	return self

func get_visibility_changed() -> bool:
	return _visibility_changed
