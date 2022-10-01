extends KinematicBody2D

class_name Vamp


const SPEED := 200
const JUMP_STRENGTH := -300.0
const damage = 50
const dodge_cd_value = 5

var GRAVITY := 600

var velocity = Vector2()

onready var vamp_state_trapped = 0
var rotated = false

var player_substate = "idle"
var dodge_allowed_substates = ['idle','running']
var attack_allowed_substates = ['idle','running']
var stunned
var did_damage = 0

onready var player :=$"."
onready var animation := $AnimationPlayer
onready var sprite := $AnimatedSprite
onready var label := $Label
onready var attack_time = $Attack/AttackTime
onready var attack_hitbox = $Attack
onready var stun_timer = $StunTimer
onready var dodge_cd_bar = $DodgeSkill/DodgeCDBar
onready var dodge_cd_timer = $DodgeSkill/DodgeCDTimer
onready var dodge_state_timer = $DodgeSkill/DodgeStateTimer
onready var hunter = get_node("../Hunter")

func _ready():
	velocity.y = 0
	velocity.x = 0
	dodge_cd_bar.max_value = dodge_cd_value

func _physics_process(delta):
	_handle_skills()
	if vamp_state_trapped == 0:
		_handle_movement(delta)

func _process(delta):
	dodge_cd_bar.value = dodge_cd_timer.time_left
	
func _handle_movement(delta):
	if player_substate == "running":
		player_substate = "idle"
		animation.play("Idle")
	velocity.x = 0
	var x_input := Input.get_action_strength("move_v_right") - Input.get_action_strength("move_v_left")
	var y_input := 0
	
	velocity.x += x_input * SPEED
	velocity.y += GRAVITY * delta
	
	var vector_input := Vector2(x_input, y_input);
	
	if (vector_input.length() == 0) and (player_substate == "idle"):
		velocity = move_and_slide(velocity, Vector2(0,-1))
		return;	
	
	if player_substate=="idle": #in allowed_substates_run: #будет бежать, если не использует скилы кроме блока)
		player_substate = "running"
		animation.play("Run")
		
	if (vector_input.x < 0 and !rotated):
		dodge_cd_bar.rect_scale*=Vector2(-1,1)
		label.rect_scale*=Vector2(-1,1)
		rotated = true
		scale.x = -scale.x
	if (vector_input.x > 0 and rotated):
		dodge_cd_bar.rect_scale*=Vector2(-1,1)
		label.rect_scale*=Vector2(-1,1)
		rotated = false
		scale.x = -scale.x
			
	velocity = move_and_slide(velocity, Vector2(0,-1))

#func _clone():
	#player.instance()
func _handle_skills():
	if Input.is_action_just_pressed("vamp_attack") and (player_substate in attack_allowed_substates):
		attack_time.start(2)
		attack_hitbox.monitoring = 1
		player_substate = "attacking"
		animation.play("Attack")
	if Input.is_action_just_pressed("vamp_dodge") and (player_substate in dodge_allowed_substates) and dodge_cd_timer.time_left == 0:
		dodge_cd_timer.start(dodge_cd_value)
		animation.play("Dodge")
		player_substate = "dodge"
		dodge_state_timer.start(1)
		#player.set_collision_mask_bit(8,false)
		
		
		
		
func stun():
	if player_substate == 'dodge':
		stunned = 0
	else:
		stunned = 1
		vamp_state_trapped=1
	return stunned

#signals
func _on_Attack_body_entered(body):
	if body is Hunter and (did_damage == 0):
		body.damage(damage)
		did_damage = 1


func _on_AttackTime_timeout():
	attack_hitbox.monitoring = 0
	player_substate = "idle"
	did_damage = 0


func _on_DodgeStateTimer_timeout():
	player_substate = "idle"
