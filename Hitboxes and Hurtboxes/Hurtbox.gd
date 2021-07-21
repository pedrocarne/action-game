extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

onready var timer = $Timer

var invincible = false setget set_invincible

signal invicibillity_started
signal invicibillity_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invicibillity_started")
	else:
		emit_signal("invicibillity_ended")

func start_invencibillity(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _on_Timer_timeout():
	self.invincible = false


func _on_Hurtbox_invicibillity_started():
	set_deferred("monitorable", false)

func _on_Hurtbox_invicibillity_ended():
	monitorable = true
