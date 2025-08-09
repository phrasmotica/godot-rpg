extends Node

var _transitions_gate := UITransitionsGate.new()
var _transition_factory := UITransitionFactory.new()

signal started(transition: UITransition)

func add(tile: Tile) -> void:
    _transitions_gate.reset()

    if tile.transitions_on_interact.size() <= 0:
        finish(tile)
        return

    for t in tile.transitions_on_interact:
        _transitions_gate.hold()

        var transition := _transition_factory.create(t)
        started.emit(transition)

        transition.finished.connect(finish.bind(tile), CONNECT_ONE_SHOT)

func finish(tile: Tile) -> void:
    if _transitions_gate.release():
        DialogueManager.start_timeline(tile.dialogue_timeline)
