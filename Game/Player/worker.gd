extends CharacterBody2D

@export var speed = 125 # How fast the player will move (pixels/sec).
@export var maxlife = 1000.
@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")
@onready var BloodParticle: GPUParticles2D = get_node("ParticleInterface/BloodParticle")
#@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")
#@onready var BloodParticle: GPUParticles2D = get_node("ParticleInterface/BloodParticle")
var life = maxlife
var startpos = Vector2.ZERO
var minepos = Vector2.ZERO
var worker_3rd_pos = Vector2.ZERO
var worker_4rd_pos = Vector2.ZERO
#var Base_pos = Vector2.ZERO
#var screen_size # Size of the game window.
#var i_nav=0
#var player_chase = false
#var player_attack = false
var interact_trigger = false
var interact_stand_trigger = false
var flee_trigger = false
var idle_after_flee_end_trigger = false
var i_idle_after_flee = 0
var player = null
var frame_alt = 0
var frame_neu = 0
var backpack = 0
#var max_backpack = 1



func _physics_process(_delta):
	
	$ProgressBar.set_value_no_signal(life*100/maxlife)	
	#if player != null:
	#	print(player.name)
	if flee_trigger and player != null:
		$AnimatedSprite2D.animation = "flee"
		velocity = (position - player.position).normalized()*speed
		if velocity.x > 0:
			#$AnimatedSprite2D.animation = "flee"
			$AnimatedSprite2D.flip_h = false
		elif velocity.x < 0:
			#$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play()
	elif ( idle_after_flee_end_trigger == true or player == null) and flee_trigger == true:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.animation = "idle"
		if $AnimatedSprite2D.animation == "idle" and $AnimatedSprite2D.frame == 5:
			i_idle_after_flee += 1
			if i_idle_after_flee == 10 or player == null:
				flee_trigger = false
				idle_after_flee_end_trigger = false
				i_idle_after_flee = 0
	elif interact_trigger:# and player != null:
		
		if interact_stand_trigger:
			velocity = Vector2.ZERO
			interact_stand_trigger = false
		if player != null:
			if player.name == "BaseCastle":
				$AnimatedSprite2D.animation = "idle"
				if $AnimatedSprite2D.frame == 5:
					player = null
					interact_trigger = false
					init_target_position(minepos)
					#_getGold()
			elif player.name == "GoldMine":
				$AnimatedSprite2D.animation = "mine"
				if $AnimatedSprite2D.frame == 5:
					player = null
					interact_trigger = false
					init_target_position(worker_3rd_pos)
				#_draftgold()
			elif player.name == "Worker_3rd_pos":
				player = null
				interact_trigger = false
				#print($BaseCastle.position)
				init_target_position(worker_4rd_pos)
			elif player.name == "Worker_4rd_pos":
				player = null
				interact_trigger = false
				#print($BaseCastle.position)
				init_target_position(startpos)
		else: 
			interact_trigger = false
			
	else:
		if interact_trigger != false or interact_stand_trigger != false or flee_trigger != false or idle_after_flee_end_trigger != false:
			print(interact_trigger, interact_stand_trigger, flee_trigger,idle_after_flee_end_trigger)
			interact_trigger = false
			interact_stand_trigger = false
			flee_trigger = false
			idle_after_flee_end_trigger = false
		if navigation_agent.is_navigation_finished():
				return
		else:
			#if i_nav == 0:
			#var target_position: Vector2 = navigation_agent.target_position
			var next_path_position: Vector2 = navigation_agent.get_next_path_position()
			var current_agent_position: Vector2 = navigation_agent.get_parent().position
			#next_path_position -= current_agent_position
			var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized() * speed
			velocity = new_velocity
			#print(target_position, current_agent_position, next_path_position)
		if velocity == Vector2.ZERO:
			$AnimatedSprite2D.animation = "idle"
			$AnimatedSprite2D.flip_h = false
		elif velocity.x > 0:
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_h = false
		elif velocity.x < 0:
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play()	

	move_and_slide()

func init_target_position(navigation_target_pos : Vector2):
	$NavigationAgent2D.set_target_position(navigation_target_pos)

func init_bloodparticles(direction : Vector3):
	BloodParticle.get_process_material().direction = direction



func _on_interact_area_area_entered(area):
	#print("test")
	player = area.get_parent()
	if player.name == "BaseCastle" and backpack != 0:
		interact_trigger = true
		interact_stand_trigger = true
		Global.Player.gold +=1
		backpack = 0
	elif player.name == "GoldMine" and backpack == 0:
		interact_trigger = true
		interact_stand_trigger = true
		backpack = 1
	elif player.name == "Worker_3rd_pos" and backpack != 0:
		interact_trigger = true
	elif player.name == "Worker_4rd_pos" and backpack != 0:
		interact_trigger = true
	#else: 
	#	print("oops:", player.name, backpack)
	


func _on_flee_area_body_entered(body):
	#print("flee")
	player = body
	flee_trigger = true

func _on_stop_flee_area_body_exited(_body):
	#print("exit")
	player = null
	idle_after_flee_end_trigger = true
	#flee_trigger = false


#func _draftgold():
#	if !backpack >= max_backpack:
#		backpack +=1
#		print("draft")

#func _getGold():
#	if backpack >= 0:
#		backpack -=1
#		Global.Player.gold +=1
#		print("getgold")
