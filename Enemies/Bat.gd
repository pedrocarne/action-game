extends KinematicBody2D

var knockback = Vector2.ZERO

onready var stats = $Stats #takes the Stats Scene to a variable

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	stats.health -= 1
	print(stats.health);
	knockback = area.knockback_vector * 110
	


func _on_Stats_no_health():
	queue_free()
