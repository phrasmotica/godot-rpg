class_name ItemEffect extends Resource

signal consume(effect: ItemEffect)

func apply():
    consume.emit(self)

func apply_to_hit_points(_hit_points: HitPoints):
    print("Applying item effect to hit points")

# TODO: define more methods for applying the effect to other parts of the game
