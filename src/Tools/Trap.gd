extends Area2D

onready var texture_open = $Open
onready var texture_closed = $Closed
onready var vamp = get_node("../Vamp")
onready var hunter = get_node("../Hunter")
onready var timer = $Timer
onready var closed = 0
onready var pickable = 0



func _on_Node2D_body_entered(body):
	if body is Vamp and (closed == 0):
		texture_open.visible = 0
		texture_closed.visible = 1
		var stunned = body.stun()
		if stunned == 1:
			timer.start(3)
		else:
			 pickable = 1
		closed = 1
	elif body is Hunter and (closed==1) and (pickable==1):
		hunter.max_traps+=1
		queue_free()






func _on_Timer_timeout():
	vamp.vamp_state_trapped = 0
	pickable=1
	
