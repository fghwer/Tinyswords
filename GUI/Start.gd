extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#Global.Player.gold = 4
	#Global.Player.score = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#test3
#test

func _on_button_labor_pressed():
	get_tree().change_scene_to_file("res://labor.tscn")


func _on_button_level_1_pressed():
	get_tree().change_scene_to_file("res://Level/Level_1/Level_1.tscn")
