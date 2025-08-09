class_name BagMenuStateData

var _visibility_changed := false
var _was_uncovered := false

static func build() -> BagMenuStateData:
	return BagMenuStateData.new()

func with_visibility_changed(visibility_changed: bool) -> BagMenuStateData:
	_visibility_changed = visibility_changed
	return self

func get_visibility_changed() -> bool:
	return _visibility_changed

func with_was_uncovered(was_uncovered: bool) -> BagMenuStateData:
	_was_uncovered = was_uncovered
	return self

func get_was_uncovered() -> bool:
	return _was_uncovered
