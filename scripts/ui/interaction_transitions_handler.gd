class_name InteractionTransitionsHandler extends Node

var _transitions_gate := UITransitionsGate.new()
var _transition_factory := UITransitionFactory.new()

signal finished(tile: Tile)

func handle_interaction(tile: Tile) -> void:
    _transitions_gate.reset()

    if tile.transitions_on_interact.size() <= 0:
        finished.emit(tile)
        return

    for t in tile.transitions_on_interact:
        _transitions_gate.hold()

        var transition := _transition_factory.create(t)

        add_child(transition)
        transition.owner = self

        transition.finished.connect(
            func():
                if _transitions_gate.release():
                    finished.emit(tile)
        , CONNECT_ONE_SHOT)
