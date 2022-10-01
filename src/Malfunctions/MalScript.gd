extends Area2D

onready var light = $Light
onready var timer = $Timer
onready var label = $Label
onready var progress = $ProgressBar
onready var debug = $debug

onready var keys = ['q','w','e','r','t']
onready var repair_key
onready var random = RandomNumberGenerator.new() 

onready var player_enter_state = 0

func _ready():
	random.randomize()
	timer.start(3)


func _process(delta):
	_handle_repair(delta)

func _handle_repair(delta):
	if progress.visible == true:
		if Input.is_action_just_pressed(repair_key) and player_enter_state == 1:
			progress.value+=1.5
		progress.value-=delta
	


#signals
#Emit light when player enters
func _on_Node2D_body_entered(body):
	if body is Hunter:
		light.visible = 1
		player_enter_state = 1
#Stop emiting light
func _on_Node2D_body_exited(_body):
	if _body is Hunter:
		player_enter_state = 0
	light.visible = 0

#Object brokes on timer
func _on_Timer_timeout():
	random.randomize()
	repair_key = keys[random.randi() % keys.size()]
	label.set_text("Дрочи " + repair_key + ", чтобы чинить")
	label.visible = 1
	progress.visible = 1
#when repaired
func _on_ProgressBar_value_changed(value):
	if value == 100:
		progress.visible=0
		label.visible=0
		progress.value=50
		timer.start(random.randi_range(5,8))
	#if value == 0:
		#game_over

	
