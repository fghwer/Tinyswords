extends Node2D
# Packed Scenes
@export var mob_scene: PackedScene
@export var knight_scene : PackedScene
@export var worker_scene : PackedScene
@export var wood_worker_scene : PackedScene
@export var archer_scene : PackedScene
@export var house_scene : PackedScene
@export var tower_scene = load("res://Game/Buildings/base_tower.tscn")

# Player Buttons
@onready var SpawnKnightButtonLabel: Label = get_node("PlayerButtons/SpawnKnightButton/ButtonLayout/Label")
@onready var SpawnWorkerButtonLabel: Label = get_node("PlayerButtons/SpawnWorkerButton/ButtonLayout/Label")
@onready var SpawnArcherButtonLabel: Label = get_node("PlayerButtons/SpawnArcherButton/ButtonLayout/Label")
@onready var SpawnWoodWorkerButtonLabel: Label = get_node("PlayerButtons/SpawnWoodWorkerButton/ButtonLayout/Label")

# Building Buttons
@onready var SpawnHouseButtonLabel: Label = get_node("BuildingButtons/SpawnHouseButton/ButtonLayout/Label")
@onready var SpawnTowerButtonLabel: Label = get_node("BuildingButtons/SpawnTowerButton/ButtonLayout/Label")

#@onready var navigation_agent: NavigationAgent2D = get_node("mob_scene/NavigationAgent2D")
#@export var knight_scene : PackedScene
var startpos_knight = Vector2.ZERO
var waiting_for_click = false
var knight_to_spawn = null
var archer_to_spawn = null
var house_to_spawn = null
var tower_to_spawn = null

#Gold 
var cost_knight_gold = 2
var cost_worker_gold = 2
var cost_archer_gold = 3
var cost_house_gold = 10
var cost_wood_worker_gold = 2

#Wood
var cost_archer_wood = 1
var cost_house_wood = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	print($UpgradeBanner.get_path())
	Global.Player.gold = 10
	Global.Player.populationMax = 10
	Global.Player.score = 0
	Global.Player.wood = 5
	SpawnKnightButtonLabel.set_text(str(cost_knight_gold))
	SpawnWorkerButtonLabel.set_text(str(cost_worker_gold))
	SpawnWoodWorkerButtonLabel.set_text(str(cost_worker_gold))
	SpawnArcherButtonLabel.set_text(str(cost_archer_gold))
	SpawnHouseButtonLabel.set_text(str(cost_house_gold))
	$PlayerButtons.visible = false
	$BuildingButtons.visible = false
	
	
	$MobTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	#if Input.is_action_just_pressed("spawn_knight"):
	#	_on_spawn_knight_button_button_up()
	#elif Input.is_action_just_pressed("spawn_worker"):
	#	_on_spawn_worker_button_pressed()
	#elif Input.is_action_just_pressed("spawn_archer"):
	#	_on_spawn_archer_button_button_up()
	if waiting_for_click and Input.is_action_just_pressed("click"):
		if house_to_spawn:
			print("waiting for click:", house_scene, house_to_spawn)
			
		if tower_to_spawn:
			print("waiting for click:", tower_scene, tower_to_spawn)
		_spawn_knight_at_mouse_position()
		_spawn_archer_at_mouse_position()
		_spawn_house_at_mouse_position()
		_spawn_tower_at_mouse_position()
		
	
	for _i in $TileMapCollection/AnimatedTerrain.get_children():
		_i.play()
		
	var gold_label = get_node("Gold")
	gold_label.set_text(str(Global.Player.gold))
	
	var score_label = get_node("Score")
	score_label.set_text("Score : " + str(Global.Player.score))
	
	var population_label = get_node("Population")
	population_label.set_text(str(Global.Player.populationMax)+ " / " + str(Global.Player.population))
	
	var wood_label = get_node("Wood")
	wood_label.set_text(str(Global.Player.wood))

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	var spawnpath = randi_range(0,200)
	#Global.Player.score += 100
	#print(spawnpath)
	#var mob_spawn_location = 0
	mob.init_target_position($BaseCastle.position)
	if spawnpath < 50:
		# Choose a random location on Path2D.
		var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
		mob_spawn_location.progress_ratio = randf()
		mob.position = mob_spawn_location.position
		
	elif spawnpath >= 50 and spawnpath < 100:
		# Choose a random location on Path2D.
		var mob_spawn_location = get_node("MobPath2/MobSpawnLocation")
		mob_spawn_location.progress_ratio = randf()
		mob.position = mob_spawn_location.position
	#mob.set_movement_target($Marker2D.position)
	elif spawnpath >= 100 and spawnpath < 150:
		# Choose a random location on Path2D.
		var mob_spawn_location = get_node("MobPath3/MobSpawnLocation")
		mob_spawn_location.progress_ratio = randf()
		mob.position = mob_spawn_location.position
	elif spawnpath >= 150:
		# Choose a random location on Path2D.
		var mob_spawn_location = get_node("MobPath4/MobSpawnLocation")
		mob_spawn_location.progress_ratio = randf()
		mob.position = mob_spawn_location.position
	add_child(mob)

#func _on_spawn_knight_button_button_up():
#	
#	if Global.Player.gold >= cost_knight:
#		knight_to_spawn = knight_scene.instantiate()
#		waiting_for_click = true
#		print("button")

		
		
		


		
		


func _on_spawn_worker_button_pressed():
	
	if Global.Player.gold >= cost_worker_gold && Global.Player.populationMax > Global.Player.population:
		
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
		Global.Player.gold -= cost_worker_gold
		Global.Player.population += 1
	


#func _on_spawn_archer_button_button_up():
#		
#	if Global.Player.gold >= cost_archer:
#		archer_to_spawn = archer_scene.instantiate()
#		waiting_for_click = true
			



func _on_spawn_archer_button_pressed():
	if Global.Player.gold >= cost_archer_gold && Global.Player.wood >= cost_archer_wood && Global.Player.populationMax > Global.Player.population:
		archer_to_spawn = archer_scene.instantiate()
		waiting_for_click = true

func _spawn_archer_at_mouse_position():
	if archer_to_spawn:
		var mouse_position = get_viewport().get_mouse_position()
		archer_to_spawn.position = mouse_position
		archer_to_spawn.startpos = mouse_position
		add_child(archer_to_spawn)
		archer_to_spawn = null
		waiting_for_click = false
		#print("spawn archer")
		Global.Player.population += 2
		Global.Player.gold -= cost_archer_gold
		Global.Player.wood -= cost_archer_wood


func _on_spawn_knight_button_pressed():
	if Global.Player.gold >= cost_knight_gold && Global.Player.populationMax > Global.Player.population:
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
		Global.Player.population += 2
		Global.Player.gold -= cost_knight_gold
		


func _on_spawn_wood_worker_button_pressed():
	
	if Global.Player.gold >= cost_wood_worker_gold && Global.Player.populationMax > Global.Player.population:
		
		var worker = wood_worker_scene.instantiate()
		var worker_spawn_location = Vector2.ZERO
		worker_spawn_location = $BaseCastle.position
		worker_spawn_location.y += 120
		worker_spawn_location.x -= 60
		var target_pos = Vector2.ZERO
		target_pos = $WoodTree.position
		target_pos.y += 50
		worker.position = worker_spawn_location
		worker.startpos = worker_spawn_location
		worker.treepos = target_pos
		worker.worker_3rd_pos = $Wood_Worker_3rd_pos.position
		worker.worker_4rd_pos = $Wood_Worker_4rd_pos.position
		worker.init_target_position(target_pos)
		add_child(worker)
		Global.Player.gold -= cost_worker_gold
		Global.Player.population += 1


# BUILDINGS
func _on_spawn_house_button_2_pressed():
	print("test")
	if Global.Player.gold >= cost_house_gold && Global.Player.wood >= cost_house_wood :
		house_to_spawn = house_scene.instantiate()
		waiting_for_click = true
		print("button")

func _spawn_house_at_mouse_position():
	if house_to_spawn:
		var mouse_position = get_viewport().get_mouse_position()
		house_to_spawn.position = mouse_position
		house_to_spawn.startpos = mouse_position
		add_child(house_to_spawn)
		house_to_spawn = null
		waiting_for_click = false
		print("spawn")
		Global.Player.populationMax += 10
		Global.Player.gold -= cost_house_gold
		Global.Player.wood -= cost_house_wood
		
		
		


func _on_spawn_tower_button_pressed():
	print("tower")
	if Global.Player.gold >= cost_house_gold && Global.Player.wood >= cost_house_wood :
		tower_to_spawn = tower_scene.instantiate()
		waiting_for_click = true
		print("button")



func _spawn_tower_at_mouse_position():
	if tower_to_spawn:
		var mouse_position = get_viewport().get_mouse_position()
		tower_to_spawn.position = mouse_position
		tower_to_spawn.startpos = mouse_position
		add_child(tower_to_spawn)
		tower_to_spawn = null
		waiting_for_click = false
		print("spawn")
		Global.Player.gold -= cost_house_gold
		Global.Player.wood -= cost_house_wood
		




func _on_extend_player_button_pressed():
	$PlayerButtons.visible = true
	$ExtendButtons/ExtendPlayerButton.visible = false



func _on_cut_player_button_pressed():
	$PlayerButtons.visible = false
	$ExtendButtons/ExtendPlayerButton.visible = true
	
	



func _on_extend_building_button_pressed():
	$BuildingButtons.visible = true
	$ExtendButtons/ExtendBuildingButton.visible = false
	



func _on_cut_building_button_pressed():
	$BuildingButtons.visible = false
	$ExtendButtons/ExtendBuildingButton.visible = true
