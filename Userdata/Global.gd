extends Node

var Player = User.new()

var knight_maxlife = 1000
var knight_speed = 75

func _process(_delta):
	if Player.score >= 100 && Player.level == 1:
		level_up()


func level_up():
	Player.level += 1
	#Player.score = 0
	print("level Up")
	get_tree().paused = true
	get_node("/root/Level_nav/CollectionCharacters/UpgradeBanner").visible = true




func _on_update_button_1_pressed():
	print("test1")	
	get_node("/root/Level_nav/CollectionCharacters/UpgradeBanner").visible = false
	get_node("root/")
	knight_maxlife += 500
	get_tree().paused = false
	

func _on_update_button_2_pressed():
	print("test2")
	get_node("/root/Level_nav/CollectionCharacters/UpgradeBanner").visible = false
	get_tree().paused = false


func _on_update_button_3_pressed():
	print("test3")
	get_node("/root/Level_nav/CollectionCharacters/UpgradeBanner").visible = false
	knight_speed += 100
	get_tree().paused = false
