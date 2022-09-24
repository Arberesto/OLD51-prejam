extends Node2D

class_name ZCorrector

onready var parent := get_parent() as Node2D


func _process(delta):
	parent.z_index = parent.position.y
