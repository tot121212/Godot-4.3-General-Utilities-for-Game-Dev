extends Node2D

var root

func execute_jump():
	pass

var coyote_timer
var jump_buffer_timer

func _physics_process(delta):
	if Input.is_action_just_pressed("up"):
		if root.is_on_floor():
			root.reset_available_jumps()
			execute_jump()
		else:
			if not coyote_timer.is_stopped() and root.available_jumps > 0:
				execute_jump()
			
			else: # jump input is stored if we are not on floor or we have no available jumps/the coyote timer is not active
				jump_buffer_timer.start() # start timer
	elif not jump_buffer_timer.is_stopped() and root.is_on_floor(): # if buffer has jump stored and we hit ground
		root.reset_available_jumps()
		execute_jump()
