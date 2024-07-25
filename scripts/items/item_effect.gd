class_name ItemEffect extends Resource

signal consume(effect: ItemEffect)

func apply():
    consume.emit(self)

func apply_to_player(_player: Player):
    print("Applying item effect to player")

# TODO: define more methods for applying the effect to other parts of the game
