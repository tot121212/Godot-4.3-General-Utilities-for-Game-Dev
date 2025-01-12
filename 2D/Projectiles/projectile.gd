extends CharacterBody2D
class_name Projectile
# Inherit from Projectile and call the move_slide_and_handle_collisions function with the result of move_and_slide()
# Please view ProjectileDescendentExample.tscn for an example.

signal on_collision_with_node

func move_slide_and_handle_collisions(is_colliding): # requires move and slide result as input
	if is_colliding:
		handle_collisions()

func handle_collisions():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		print("Collided with: ", collision.get_collider().name)
		
		if collider is Node:
			on_collision_with_node.emit(collider)
