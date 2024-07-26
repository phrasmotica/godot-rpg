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

@export
var external_effects: Array[ItemEffect] = []

@export
var meta := {}
