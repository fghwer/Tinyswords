extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _on_button_home_pressed():
	pass # Replace with function body.


func _on_button_restart_pressed():
	Global.Player.gold = 100
	Global.Player.score = 0
	get_tree().change_scene_to_file("res://nav_goblin_testscene.tscn")
	
