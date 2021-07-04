extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 100
const FRICTION = 500

var velocity = Vector2.ZERO
onready var animationPlayer = $AnimationPlayer #Turn the animations into a variable inside the _ready funcion
onready var animationTree = $AnimationTree #Turn the animations Tree into a variable

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")#gets the datas of right and left arrow keys
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")#gets the datas of down and up arrow keys
	input_vector = input_vector.normalized()#makes the character runs at the same speed in all directions	
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		#velocity += input_vector * ACCELERATION * delta#makes the character move with acceleration frame based
		#velocity = velocity.clamped(MAX_SPEED) * delta#clamping the velocity by max speed and making it frame based
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)#adding friction and making it frame based
	
	print(velocity) 
	velocity = move_and_slide(velocity)
