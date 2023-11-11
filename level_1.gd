extends Node2D

const PLAYER_SCENE_PATH: String = "res://area_2d.tscn"
const ENEMY_SCENE_PATH: String = "res://goblin.tscn"
# Called when the node enters the scene tree for the first time.
func _ready():
	# Pfade zu den Szenen
	
	# Instanziieren und dem Level hinzufügen
	var player_instance = preload(PLAYER_SCENE_PATH).instance()
	add_child(player_instance)
	player_instance.visible = true
	player_instance.position = Vector2(200, 500)


	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	# Hier kannst du weitere Logik für jeden Frame hinzufügen

#func _on_button_pressed():
##    Hier könntest du Code hinzufügen, um bei einem Knopfdruck eine Instanz zu erstellen
#	var player_instance = preload(player_scene_path).instance()
#	add_child(player_instance)
#	print("Player erstellt")
