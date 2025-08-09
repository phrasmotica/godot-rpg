extends Node

var _transitions_gate := UITransitionsGate.new()
var _transition_factory := UITransitionFactory.new()

signal started(transition: UITransition)
signal finished(item: Item)

func add(item: Item) -> void:
    _transitions_gate.reset()

    if item.consume_transitions.size() <= 0:
        finished.emit(item)
        return

    for t in item.consume_transitions:
        _transitions_gate.hold()

        var transition := _transition_factory.create(t)
        started.emit(transition)

        transition.finished.connect(finish.bind(item), CONNECT_ONE_SHOT)

func finish(item: Item) -> void:
    if _transitions_gate.release():
        finished.emit(item)
