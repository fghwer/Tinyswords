extends CharacterBody2D

signal hit 
@export var maxlife = 1000.
@export var speed = 75 # How fast the player will move (pixels/sec).
@onready var BloodParticle: GPUParticles2D = get_node("ParticleInterface/BloodParticle")
var startpos = Vector2.ZERO
var life = maxlife
var screen_size # Size of the game window.
var i = 0
var player_chase = false
var player_attack = false
var player = null
var frame_alt = 0
var frame_neu = 0

#const SPEED = 50.0
#const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(_delta):
	
	$ProgressBar.set_value_no_signal(life*100/maxlife)

	
	#move_and_slide()
	if player_attack and player != null:
		
		velocity = Vector2.ZERO
		if abs(player.position.x - position.x) >= abs(player.position.y - position.y):
			$AnimatedSprite2D.animation = "attack"
		elif (player.position.y < position.y):
			$AnimatedSprite2D.animation = "attack_top"
		else:
			$AnimatedSprite2D.animation = "attack_bot"
		if(player.position.x - position.x) < 0: # player ist knight
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		if player.life <= 0:
			player.hide()
			player_attack = false
			player_chase = false
			player = null
		$AnimatedSprite2D.play()
		frame_neu = $AnimatedSprite2D.frame
		if frame_alt != frame_neu && (frame_neu == 4 or frame_neu == 10) && player != null:
			if player.life != null:
				if player.life > 0:
					player.life -= 100
			player.BloodParticle.emitting = true
			var blood_direction = Vector3.ZERO
			blood_direction.x = player.position.x - position.x
			blood_direction.y = player.position.y - position.y
			player.init_bloodparticles(blood_direction)
			if player.life <= 0:
				Global.Player.score += 100
				player.queue_free()
			#player.set_hpbar_value(player.life/player.maxlife)
			#print(player, player.life)
		#print(frame_alt,frame_neu)
		frame_alt = frame_neu
				
		
	elif player_chase and player != null:
		#print("chase")
		velocity = (player.position - position).normalized()*speed
		$AnimatedSprite2D.animation = "walk"
		if(player.position.x -position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play()
		
	elif pow(startpos.x - position.x,2) + pow(startpos.y - position.y,2)  > 100:
		#print("hi")
		velocity = (startpos - position).normalized()*speed
		$AnimatedSprite2D.animation = "walk"
		if(startpos.x -position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play()
	else:
		#print("hello")
		velocity = Vector2.ZERO
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play()
	move_and_slide()

#func set_startposition( KnightSpawnLocation : Vector2 ):
#	position = KnightSpawnLocation

#func distance_startpoint( KnightSpawnLocation : Vector2 ):
#	var distance = pow(KnightSpawnLocation.x - position.x,2) + pow(KnightSpawnLocation.y - position.y,2)
#	return distance
	
func init_bloodparticles(direction : Vector3):
	BloodParticle.get_process_material().direction = direction
	

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	
func _on_detection_area_body_exited(_body):
	player = null
	player_chase = false
	
func _on_attack_area_body_entered(body):
	player = body
	player_attack = true
	player_chase = false
	
func _on_attack_area_body_exited(_body):
	player_attack = false
	player_chase = true
