extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50 
export var FRICTION = 200

enum{
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = IDLE

onready var sprite = $Sprite
onready var stats = $Stats #takes the Stats Scene to a variable
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollisions = $SoftCollision
onready var wanderController = $WanderController

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(rand_range(1,3))
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(rand_range(1,3))
			var direction = global_position.direction_to(wanderController.target_position)
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			sprite.flip_h = velocity.x < 0
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				sprite.flip_h = velocity.x < 0
			else:
				state = IDLE
				
	if softCollisions.is_colliding():#adds to the velocity a new vector that pushes the bodies when they collide
		velocity += softCollisions.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
		
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	print(stats.health);
	knockback = area.knockback_vector * 110
	hurtbox.create_hit_effect()
	
func _on_Stats_no_health():
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	queue_free()
