extends Node
class_name ProjectileContainer
# When this node would be deleted, instead it orphans all projectile children to the OrphanProjectileContainer that exists under root

var orphan_container : Node

func _ready() -> void:
	orphan_container = get_tree().get_first_node_in_group("OrphanProjectileContainer")
	if not orphan_container:
		var new = OrphanProjectileContainer.new()
		get_tree().root.add_child(new)
		await new.ready
		orphan_container = get_tree().get_first_node_in_group("OrphanProjectileContainer")
	if not orphan_container:
		push_error("No OrphanProjectileContainer can be created")

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			on_predelete()

func on_predelete() -> void:
	var children = get_children()
	if children:
		for child in children:
			child.reparent(orphan_container)
