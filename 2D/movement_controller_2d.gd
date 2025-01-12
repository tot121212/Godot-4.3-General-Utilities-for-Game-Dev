extends Node
class_name MovementController2D
## For basic movement and aiming

signal input_direction_changed
signal secondary_input_direction_changed

@export var body : CharacterBody2D

@export var debug_raycasts_parent : Node
var debug_raycasts : Array[RayCast2D] = []

var last_input_direction : Vector2 = Vector2.RIGHT
var input_direction : Vector2 = Vector2.ZERO

var secondary_last_input_direction : Vector2 = Vector2.RIGHT
var secondary_input_direction : Vector2 = Vector2.ZERO

var was_on_floor : bool = true

func _ready():
	for raycast in debug_raycasts_parent.get_children(): # These raycasts show where joysticks and such are pointing
		if raycast is RayCast2D:
			debug_raycasts.append(raycast)

func _physics_process(_delta):
	update_input_direction()
	update_secondary_input_direction()
	debug_raycasts[0].rotation = Vector2.RIGHT.angle_to(input_direction)
	debug_raycasts[1].rotation = Vector2.RIGHT.angle_to(secondary_input_direction)
	
func update_input_direction():
	if (last_input_direction != input_direction 
	and input_direction != Vector2.ZERO):
		last_input_direction = input_direction
	input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	input_direction_changed.emit(input_direction)

func update_secondary_input_direction():
	if (secondary_last_input_direction != secondary_input_direction 
	and secondary_input_direction != Vector2.ZERO):
		secondary_last_input_direction = secondary_input_direction
	secondary_input_direction = Vector2(
		Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"),
		Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
	)
	secondary_input_direction_changed.emit(secondary_input_direction)
