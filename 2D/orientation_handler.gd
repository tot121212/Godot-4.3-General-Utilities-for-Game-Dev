extends Node
class_name OrientationHandler

@export var body : Node2D ## should have a change_orientation
@export var nodes_to_flip : Array[NodePath] ## nodes to flip orientation of, can be sprites or anything else, part of the body
@export var should_rotate : bool = false ## use for omni-directional projectiles
@export var start_facing_right = true ## should the nodes start facing right when loading scene
@export var ignore_orientation_changes : bool = false ## bool to ignore any inputs to change orientation, for testing

func _ready():
	body.change_orientation.connect(_on_change_orientation) ## connects body change_orientation signal to callable
	if not start_facing_right:
		body.change_orientation.emit(Vector2.LEFT)

var last_orientation : Vector2 = Vector2.RIGHT
func _on_change_orientation(direction : Vector2):
	if ignore_orientation_changes:
		return
	direction = Vector2(snappedf(direction.x, 0.01), snappedf(direction.y, 0.01))
	if last_orientation == direction:
		return
	for node_path in nodes_to_flip:
		var node = get_node_or_null(node_path)
		if not node:
			continue
		
		if direction.x > 0:
			node.scale.x = abs(node.scale.x)
		elif direction.x < 0:
			node.scale.x = -abs(node.scale.x)
		
		if should_rotate:
			if direction.x > 0:
				node.rotation = Vector2.RIGHT.angle_to(direction)
			elif direction.x < 0:
				node.rotation = Vector2.LEFT.angle_to(direction)
			else: # only do these if x is 0
				node.rotation = Vector2.RIGHT.angle_to(direction)
		
		last_orientation = direction
