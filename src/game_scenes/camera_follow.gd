extends Camera2D

onready var follow_target := get_node("../Player") as Node2D

var left_position : float

func _ready():
	left_position = follow_target.position.x

func _process(delta):
	position = Vector2(max(follow_target.position.x, left_position), position.y)
