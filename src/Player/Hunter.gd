extends KinematicBody2D

class_name Hunter


const SPEED := 200
const JUMP_STRENGTH := -300.0

var HP = 100
var GRAVITY := 600

var velocity = Vector2()

var rotated = false

var player_substate = "idle" 

onready var max_traps = 3

onready var player :=$"."
onready var animation := $AnimationPlayer
onready var sprite := $AnimatedSprite
onready var label := $Label
onready var hpbar = $HPBar
onready var vamp = get_node("../Vamp")

func _ready():
	velocity.y = 0
	velocity.x = 0

func _physics_process(delta):
	_handle_movement(delta)

func _process(delta):
	hpbar.value = HP
		
func _handle_movement(delta):
	if player_substate == "running":
		player_substate = "idle"
		animation.play("Idle")
	velocity.x = 0
	var x_input := Input.get_action_strength("move_h_right") - Input.get_action_strength("move_h_left")
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
		label.rect_scale*=Vector2(-1,1)
		rotated = true
		scale.x = -scale.x
	if (vector_input.x > 0 and rotated):
		label.rect_scale*=Vector2(-1,1)
		rotated = false
		scale.x = -scale.x
			
	velocity = move_and_slide(velocity, Vector2(0,-1))

func damage(dmg):
	HP-=dmg
	if HP<=0:
		died()
	
func died():
	queue_free()
	
#func _clone():
	#player.instance()
