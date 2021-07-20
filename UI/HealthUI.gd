extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var HeartsUIFull = $HeartUIFull
onready var HeartsUIEmpty = $HeartUIEmpty

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if HeartsUIFull != null:
		HeartsUIFull.rect_size.x = hearts * 15 #makes the rect size to be the value of the hearts

func set_max_hearts(value):
	max_hearts = max(value, 1)
	if HeartsUIEmpty != null:
		HeartsUIEmpty.rect_size.x = max_hearts * 15

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
	
