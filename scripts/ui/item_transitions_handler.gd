class_name ItemTransitionsHandler extends Node

@export
var transitions_gate: UITransitionsGate

@export
var transition_factory: UITransitionFactory

signal finished(item: Item)

func handle_item(item: Item) -> void:
    if not transitions_gate:
        finished.emit(item)
        return

    transitions_gate.reset()

    if not transition_factory:
        finished.emit(item)
        return

    if item.consume_transitions.size() <= 0:
        finished.emit(item)
        return

    for t in item.consume_transitions:
        transitions_gate.hold()

        var transition := transition_factory.create(t)

        transition.finished.connect(
            func():
                if transitions_gate.release():
                    finished.emit(item)
        , CONNECT_ONE_SHOT)
