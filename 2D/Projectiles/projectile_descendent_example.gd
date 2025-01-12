extends Projectile
class_name ProjectileDescendentExample

@export var projectile_component : ProjectileComponent

func _ready():
	on_collision_with_node.connect(apply_collision_effects)

func _physics_process(_delta: float) -> void:
	var is_colliding = move_and_slide()
	move_slide_and_handle_collisions(is_colliding)

func apply_collision_effects(collider): # custom collision effects based on projectile type and settings
	if collider.is_in_group("Enemy"):
		var components : Array[Node] = [
			collider.get_node_or_null("StatsComponent"),
			collider.get_node_or_null("VelocityComponent")
		]
		
		for component in components:
			if component is StatsComponent:
				if component.has_method("take_damage"): # always check for methods if its unknown what the component is
					component.take_damage(projectile_component.damage)
			if component is VelocityComponent:
				if component.has_method("take_knockback"):
					var knockback = -get_velocity()
					component.take_knockback(knockback)
	projectile_component.free_projectile.emit() # free projectile after collision, this could be call deferred if needed
