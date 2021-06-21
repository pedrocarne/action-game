extends KinematicBody2D

const ACCELERATION = 400
const MAX_SPEED = 100
var velocity = Vector2.ZERO

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")#gets the datas of right and left arrow keys
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")#gets the datas of down and up arrow keys
	input_vector = input_vector.normalized()#makes the character runs at the same speed in all directions	
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta#makes the character move with acceleration frame based
	else:
		velocity = Vector2.ZERO
	
	#print(velocity) 
	move_and_collide(velocity * delta)
