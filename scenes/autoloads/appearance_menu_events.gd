extends Node

signal editing_started

signal editing_finished

func emit_editing_started() -> void:
	editing_started.emit()

func emit_editing_finished() -> void:
	editing_finished.emit()
