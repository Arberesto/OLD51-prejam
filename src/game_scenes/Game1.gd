extends Node2D


class_name Game1

func _ready():
	#Debug_node.connect()
	var Clone = load("res://src/player/PLayer.tscn")
	
	# Add copy spawn here if button is pressed
	# IF (some button pressed):
		#var copyN = Clone.instance()
		#knight2.set_position(Vector2(-1300,164))
		#add_child(knight2)
