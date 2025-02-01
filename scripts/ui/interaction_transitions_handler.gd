class_name InteractionTransitionsHandler extends Node

@export
var transitions_gate: UITransitionsGate

@export
var transition_factory: UITransitionFactory

signal finished(tile: Tile)

func handle_interaction(tile: Tile) -> void:
    if not transitions_gate:
        finished.emit(tile)
        return

    transitions_gate.reset()

    if not transition_factory:
        finished.emit(tile)
        return

    if tile.transitions_on_interact.size() <= 0:
        finished.emit(tile)
        return

    for t in tile.transitions_on_interact:
        transitions_gate.hold()

        var transition := transition_factory.create(t)

        transition.finished.connect(
            func():
                if transitions_gate.release():
                    finished.emit(tile)
        , CONNECT_ONE_SHOT)
