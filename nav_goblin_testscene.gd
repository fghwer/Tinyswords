extends Node
@export var mob_scene: PackedScene
@export var knight_scene : PackedScene
@export var worker_scene : PackedScene
#@onready var navigation_agent: NavigationAgent2D = get_node("mob_scene/NavigationAgent2D")
#@export var knight_scene : PackedScene
var startpos_knight = Vector2.ZERO
var waiting_for_click = false
var knight_to_spawn = null
var cost_knight = 3
var cost_worker = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.Player.gold = 4
	Global.Player.score = 0
	$MobTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	if waiting_for_click and Input.is_action_just_pressed("click"):
		_spawn_knight_at_mouse_position()
		
	
	for _i in $Foam_Animation_Parent.get_children():
		_i.play()
		
	var gold_label = get_node("Gold")
	gold_label.set_text(str(Global.Player.gold))
	
	var score_label = get_node("Score")
	score_label.set_text(str(Global.Player.score) + ": Score")
	
	


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	var spawnpath = randi_range(0,100)
	Global.Player.score += 100
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
	
	if Global.Player.gold >= 3:
		knight_to_spawn = knight_scene.instantiate()
		waiting_for_click = true
		print("button")
		
		
		

func _spawn_knight_at_mouse_position():
	if knight_to_spawn:
		var mouse_position = get_viewport().get_mouse_position()
		knight_to_spawn.position = mouse_position
		knight_to_spawn.startpos = mouse_position
		add_child(knight_to_spawn)
		knight_to_spawn = null
		waiting_for_click = false
		print("spawn")
		Global.Player.gold -= 3

func _on_spawn_worker_button_pressed():
	
	if Global.Player.gold >= cost_worker:
		
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
		Global.Player.gold -= cost_worker
	
