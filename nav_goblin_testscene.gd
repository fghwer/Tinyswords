extends Node
@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	#var player = mob_scene.instantiate()
	#player.position = Vector2(500,500)
	#player.speed = 1
	#add_child(player)
	#$navigation_goblin.set_movement_target($Marker2D.position)
	$MobTimer.start()
	$knight_nav.position = $KnightSpawnLocation.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	print($MobTimer.time_left)
	#print($knight_nav.life) 
	
	for _i in $Foam_Animation_Parent.get_children():
		_i.play()
		
func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	mob.position = mob_spawn_location.position
	#mob.set_movement_target($Marker2D.position)
	
	add_child(mob)
