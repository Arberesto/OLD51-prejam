extends Node2D

onready var Player = preload("res://src/Player/Player.tscn")

onready var brokenList := $BrokenList

func _physics_process(_delta):
	if Input.is_action_just_pressed("clone"):
		_clone()
	check_broken_list()

func _clone():
	var player = Player.instance()
	add_child(player)

func check_broken_list():
	for child in brokenList.get_children():
		if child is BrokenObject and child.has_method("GetStatus"):
			if child.GetStatus() == true:
				game_over()
			
func game_over():
	# need to check score - and if it high enough, call scene to enter name?
	
	get_tree().change_scene("res://src/Scenes/End_credit.tscn")
