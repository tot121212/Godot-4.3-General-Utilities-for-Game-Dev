extends Node
class_name OrphanProjectileContainer
# Does nothing on its own, works with ProjectileContainer, gets projectiles before parent is deleted.

func _ready() -> void:
	self.add_to_group("OrphanProjectileContainer")
