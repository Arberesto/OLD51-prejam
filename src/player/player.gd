extends KinematicBody2D

class_name DragonFoe

const SPEED := 200
const JUMP_STRENGTH := -300.0
const shield_movespeed_modifier = 0.3

var GRAVITY := 600

var velocity = Vector2()

var rotated = false
var current_skills := []

var player_state := "sword"
var player_substate = "idle" #default substate. Current substates: running, doding, idle

#сабстейты, при которых разрешена активация (или переход на другой сабстейт)
const allowed_substates_run = ["idle","blocking"]

#сабстейты, при которых не разрешена активация
const unallowed_substates_attack = ["dodge"] #Неразрешённые скилы для атаки
const unallowed_substates_shield = ["dodge"] #неразрешённые скилы для щита

#Для корректного выключения щита
var shield_up = 0 #Состояние щита

#Включение и отключение возможности использования щита
var shield_on = 0


onready var singletone_stats = get_node("/root/SingletoneStats")

onready var skills := $Skills.get_children()
onready var animation := $AnimationPlayer
onready var sprite := $AnimatedSprite
onready var mawCollision := $Maw/MawCollision
onready var audioStreamPlayer := $AudioStreamPlayer2D
onready var mawAudioStreamPlayer := $Skills/MawSkill/MawAudioPlayer/

onready var game: Game1 = get_parent()

export var start_health := 40
onready var health := start_health
var is_destroyed := false

# Called when the node enters the scene tree for the first time.
func _ready():
	current_skills = skills
	velocity.y = 0
	velocity.x = 0
	

	#audioStreamPlayer.play()
	

func damage(value: int):
	health -= value
	if (health <= 0):
		destroy()
	else:
		var color_value = float(health) / start_health
		
		sprite.modulate = Color(1, color_value, color_value)

func destroy():
	if (is_destroyed):
		return
	is_destroyed = true
	
	game.on_player_death()
	
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_handle_movement(delta)
	_handle_skills(delta)
	#if Input.is_action_just_pressed("exit"):
	#	get_tree().change_scene("res://src/interface/end_menu/EndMenu.tscn")

func _handle_movement(delta):
	if player_substate == "running":
		player_substate = "idle"
	velocity.x = 0
	var x_input := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_input := 0
	if (is_on_floor() and Input.is_action_just_pressed("move_up")):
		y_input = Input.get_action_strength("move_up")
		velocity.y = y_input  * JUMP_STRENGTH
	elif (!is_on_floor()):
		y_input = 0
	
	velocity.x += x_input * SPEED
	velocity.y += GRAVITY * delta
	
	var vector_input := Vector2(x_input, y_input);
	
	if (vector_input.length() == 0) and (player_substate == "idle"):
		#player_substate = "idle"
#		if player_substate == "idle":
		mawAudioStreamPlayer.stop()
		if (player_state == "sword"):
			animation.play("idle_sword")
		
		velocity = move_and_slide(velocity, Vector2(0,-1))
		return;
	
	
	if player_substate in allowed_substates_run: #будет бежать, если не использует скилы кроме блока)
		player_substate = "running"
		
	if (vector_input.x < 0 and !rotated):
		rotated = true
		scale.x = -scale.x
	if (vector_input.x > 0 and rotated):
		rotated = false
		scale.x = -scale.x
	
	if player_substate == "running":
		mawAudioStreamPlayer.stop()
		if (player_state == "sword"):
			animation.play("run_sword")
	velocity = move_and_slide(velocity, Vector2(0,-1))

func _handle_skills(delta): 
	#skill 0 is attack
	if Input.is_action_just_pressed("skill1") and not (player_substate in unallowed_substates_attack): #main attack skill. will change substate on "attack" 
		current_skills[0].activate()

#hit:
func _on_MawSkill_hit_begins():
	player_substate = "attack"
func _on_MawSkill_hit_over():
		player_substate = "idle"
	






