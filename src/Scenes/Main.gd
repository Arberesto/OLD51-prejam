extends Node2D

onready var Player = preload("res://src/Player/Player.tscn")


func _physics_process(delta):
	if Input.is_action_just_pressed("clone"):
		_clone()

func _clone():
	var player = Player.instance()
	add_child(player)

