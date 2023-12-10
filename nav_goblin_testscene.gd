extends Node
@export var mob_scene: PackedScene
@export var knight_scene : PackedScene
@export var worker_scene : PackedScene
#@onready var navigation_agent: NavigationAgent2D = get_node("mob_scene/NavigationAgent2D")
#@export var knight_scene : PackedScene
var startpos_knight = Vector2.ZERO
var User1 = User.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	#var player = mob_scene.instantiate()
	#player.position = Vector2(500,500)
	#player.speed = 1
	#add_child(player)
	#$navigation_goblin.set_movement_target($Marker2D.position)
	#navigation_agent.set_target_position(Vector2(608,296))
	$MobTimer.start()
	
	#$knight_nav.startpos = $KnightSpawnLocation.position
	#$knight_nav.position = $KnightSpawnLocation.position
	#get_viewport().get_mouse_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print($BaseCastle.position)
	#print($knight_nav.distance_startpoint($KnightSpawnLocation.position))
	#print($MobTimer.time_left)
	#print($knight_nav.life) 
	#print(User1.gold)
	for _i in $Foam_Animation_Parent.get_children():
		_i.play()
		
	
	var label = get_node("TextEdit")
	label.set_text(str(User1.gold) + ": Gold")
	

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	var spawnpath = randi_range(0,100)
	#print(spawnpath)
	#var mob_spawn_location = 0
	mob.init_target_position($BaseCastle.position)
	if spawnpath < 50:
		# Choose a random location on Path2D.
		var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
		mob_spawn_location.progress_ratio = randf()
		mob.position = mob_spawn_location.position
		
	elif spawnpath > 1:
		# Choose a random location on Path2D.
		var mob_spawn_location = get_node("MobPath2/MobSpawnLocation")
		mob_spawn_location.progress_ratio = randf()
		mob.position = mob_spawn_location.position
	#mob.set_movement_target($Marker2D.position)
	
	add_child(mob)

func _on_spawn_knight_button_button_up():
	var knight = knight_scene.instantiate()
	var knight_spawn_location = get_viewport().get_mouse_position()
	knight.position = knight_spawn_location
	knight.startpos = knight_spawn_location
	add_child(knight)
	

func _on_spawn_worker_button_pressed():
	var worker = worker_scene.instantiate()
	var worker_spawn_location = Vector2.ZERO
	worker_spawn_location = $BaseCastle.position
	worker_spawn_location.y += 120
	var target_pos = Vector2.ZERO
	target_pos = $GoldMine.position
	target_pos.y += 50
	worker.position = worker_spawn_location
	worker.startpos = worker_spawn_location
	worker.minepos = target_pos
	worker.worker_3rd_pos = $Worker_3rd_pos.position
	worker.worker_4rd_pos = $Worker_4rd_pos.position
	worker.init_target_position(target_pos)
	add_child(worker)
