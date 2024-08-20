class_name Tile extends Resource

@export
var id: int = 0:
    set(value):
        id = maxi(0, value)

@export
var name := ""

@export
var dialogue_timeline := ""
