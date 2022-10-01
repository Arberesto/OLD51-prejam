extends Node2D

#onready var Player = preload("res://src/Player/Player.tscn")
onready var trap_scene = preload("res://src/Tools/Trap.tscn")
onready var hunter = get_node("Hunter")

#func _physics_process(delta):
	#if Input.is_action_just_pressed("clone"):
		#_clone()

func _process(delta):
	if Input.is_action_just_pressed('setup_trap') and (hunter.max_traps>0):
		_setup_trap()
		
func _setup_trap():
	hunter.max_traps-=1
	var trap = trap_scene.instance()
	trap.position = hunter.position
	add_child(trap)
	

#func _clone():
	#var player = Player.instance()
	#add_child(player)

