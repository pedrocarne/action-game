extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 100
const ROLL_SPEED = 125
const FRICTION = 500

enum{#its like an array	
	MOVE,
	ROLL,
	ATTACK
}

var velocity = Vector2.ZERO
var state =  MOVE
var roll_vector = Vector2.DOWN

onready var animationPlayer = $AnimationPlayer #Turn the animations into a variable inside the _ready funcion
onready var animationTree = $AnimationTree #Turn the animations Tree into a variable
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwHitbox

func _ready():
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")#gets the datas of right and left arrow keys
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")#gets the datas of down and up arrow keys
	input_vector = input_vector.normalized()#makes the character runs at the same speed in all directions	
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = roll_vector
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		#velocity += input_vector * ACCELERATION * delta#makes the character move with acceleration frame based
		#velocity = velocity.clamped(MAX_SPEED) * delta#clamping the velocity by max speed and making it frame based
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)#adding friction and making it frame based
	
	#print(velocity) 
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("rool"):
		state = ROLL

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()
	
func move():
	velocity = move_and_slide(velocity)
	
func roll_animation_finished():
	state = MOVE
	velocity = Vector2.ZERO
	
func attack_animation_finished():
	state = MOVE
	
