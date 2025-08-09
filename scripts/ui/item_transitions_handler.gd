class_name ItemTransitionsHandler extends Node

var _transitions_gate := UITransitionsGate.new()
var _transition_factory := UITransitionFactory.new()

signal finished(item: Item)

func handle_item(item: Item) -> void:
    _transitions_gate.reset()

    if item.consume_transitions.size() <= 0:
        finished.emit(item)
        return

    for t in item.consume_transitions:
        _transitions_gate.hold()

        var transition := _transition_factory.create(t)

        add_child(transition)
        transition.owner = self

        transition.finished.connect(
            func():
                if _transitions_gate.release():
                    finished.emit(item)
        , CONNECT_ONE_SHOT)
