extends Node
class_name VelocityComponent

## Node we are enacting velocity changes onto
@export var body : Node2D 
## Component with stats such as max_speed
@export var stats_component: StatsComponent

## Is multiplied by delta to determine how quickly or slowly acceleration can increase/decrease
@export var acceleration_coefficient : Vector2 = Vector2(640.0, 64.0)
## Base friction that is multipled by the friction coefficient and delta to move towards 0
@export var friction : float = 256

## Applys friction, moving from velocity.x, to zero, by friction * coefficient * delta
func apply_friction(delta: float, friction_coefficient : float = 1): # for moving x via friction
	body.velocity.x = move_toward(body.velocity.x, 0, (friction * friction_coefficient) * delta)

## Applysn knockback in direction
func take_knockback(knockback : Vector2): # take knockback in a direction
	body.velocity += knockback

#region Movement
## Applys movement, moving from velocity, to speed * direction, by delta * acceleration coefficient
func move(delta: float, direction: Vector2, speed : Vector2, max_speed : Vector2 = stats_component.get_max_speed()):
	# store new velocity
	var new_velocity : Vector2 = Vector2.ZERO 
	
	# normalize direction
	var direction_normalized = direction.normalized()
	
	# store new velocity, move from body velocity, to normalized direction * speed by delta * accel coefficient
	new_velocity.x = move_toward(body.velocity.x, direction_normalized.x * speed.x, acceleration_coefficient.x * delta) 
	new_velocity.y = move_toward(body.velocity.y, direction_normalized.y * speed.y, acceleration_coefficient.y * delta) 
	
	# store new velocity but clamped to max speed stat which is from the stats component by default
	body.velocity.x = clampf(new_velocity.x, -max_speed.x, max_speed.x)
	body.velocity.y = clampf(new_velocity.y, -max_speed.y, max_speed.y)
#endregion

#region Jump
## How long since the jump started
var jump_elapsed : float = 0.0
var is_jumping : bool = false

signal triggered_jump
signal canceled_jump

## Initiate jump
func jump(): 
	if is_jumping:
		return
	
	is_jumping = true
	body.velocity.y = -stats_component.initial_jump_speed
	triggered_jump.emit()

## Apply jump over time
func apply_jump(delta : float, max_speed : Vector2 = stats_component.max_speed):
	if not is_jumping:
		return
	
	jump_elapsed += delta
	
	## time factor on elapsed time / jump time
	var t : float = clamp(jump_elapsed / stats_component.jump_time, 0 , 1)
	## Ensures the jump is fast to begin and slow at the peak
	var eased_t : float = ease(t, -4.0)
	
	## Linear interpolate between init jump speed and the clamped regular jump speed, by the eased time factor
	var eased_jump_speed : float = lerp(
		-stats_component.initial_jump_speed,
		clampf(-stats_component.jump_speed, -max_speed.y, max_speed.y),
		eased_t
	)

	## Apply the acceleration factor which is the eased jump speed * 1 + the accel coefficient * delta
	var new_velocity_y = clampf(eased_jump_speed * (1 + acceleration_coefficient.y * delta), -max_speed.y, max_speed.y)
	
	body.velocity.y = new_velocity_y
	
	if jump_elapsed >= 1:
		jump_elapsed = 0.0
		is_jumping = false
		return

## Cancel jump
func cancel_jump():
	if not is_jumping:
		return
	
	is_jumping = false
	canceled_jump.emit()
#endregion
