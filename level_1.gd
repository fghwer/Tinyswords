extends Node2D

var gamestart = false
@export var mob_scene: PackedScene

const PLAYER_SCENE_PATH: String = "res://area_2d.tscn"
const ENEMY_SCENE_PATH: String = "res://goblin.tscn"
# Called when the node enters the scene tree for the first time.
func _ready():
	var player = mob_scene.instantiate()
	player.position = Vector2(500,500)
	player.speed = 1
	#add_child(player)
	$Goblin.set_movement_target($Goblin_Target.position)
	#$Goblin2.set_movement_target($Goblin_Target.position)
	#$Goblin.set_movement_target(Vector2(1000, 250))
	
	#player_instance.visible = true
	#player_instance.position = Vector2(200, 500)



	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	
	for _i in $Foam_Animation_Parent.get_children():
		_i.play()
	
	# Hier kannst du weitere Logik für jeden Frame hinzufügen

#func _on_button_pressed():
##    Hier könntest du Code hinzufügen, um bei einem Knopfdruck eine Instanz zu erstellen
#	var player_instance = preload(player_scene_path).instance()
#	add_child(player_instance)
#	print("Player erstellt")


func _on_button_play_pressed():
	gamestart = true
	#get_tree().paused = true


func _on_button_2_pressed():
	var player = mob_scene.instantiate()
	player.position = Vector2(500,500)
	player.speed = 1
	add_child(player)
