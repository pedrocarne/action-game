extends Node


export var max_health = 1 #exports the var to the editor
onready var health = max_health setget set_health #set this func every time the variable gets set
#the health only changes to the editor set if its in the ready func 

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", health)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
	
