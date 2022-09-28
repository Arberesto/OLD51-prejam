extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var edit = $LineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://src/Scenes/Main.tscn")
		


func hideNameField():
	edit.visible = false

func _on_LineEdit_text_entered(new_text):
	hideNameField()
	addNameToRecords(new_text)

func addNameToRecords(score, name):
	loadHighScore()
	if compareScoreToHighscore(score) == true:
		addToHighScore(score,name)
		saveHighScore()
	return
	
func loadHighScore():
	return
	
func saveHighScore():
	return
	
func addToHighScore(score,name):
	return

func compareScoreToHighscore(score):
	return false
