extends Skill

# 5 seconds
var cooldown = 0.5 
var current_cooldown = 0
var activated = 0
onready var mawAudioPlayer := $MawAudioPlayer
onready var Hit = get_node("../../Maw/MawCollision")

signal hit_over
signal hit_begins

func activate():
	
	if current_cooldown <= 0 :
		activated = 1
		emit_signal("hit_begins")
		get_node("../../AnimationPlayer").play("attack_sword")
		Hit.disabled = 0
		mawAudioPlayer.play()
		current_cooldown = cooldown
		
		
func _process(delta):
	if current_cooldown > 0: #start cooldown timer
		current_cooldown -= delta
	#	SingletoneStats.set_cooldown2(int(current_cooldown)) 
	if current_cooldown < 0.2 and activated == 1:
		activated = 0
		Hit.disabled = 1
		emit_signal("hit_over") # emits signal, starting changing player_substate back to idle



	
#func show_cooldown():
	#return current_cooldown
