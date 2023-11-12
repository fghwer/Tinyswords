extends Node
@export var mob_scene: PackedScene
const PLAYER_SCENE_PATH: String = "res://area_2d.tscn"
# Called when the node enters the scene tree for the first time.
func _ready():
	#var player = mob_scene.instantiate()
	#player.position = Vector2(500,500)
	#player.speed = 1
	#add_child(player)
	$navigation_goblin.set_movement_target($Marker2D.position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for _i in $Foam_Animation_Parent.get_children():
		_i.play()
