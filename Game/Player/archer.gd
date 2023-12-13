extends CharacterBody2D

@export var maxlife = 700.
@export var speed = 40 # How fast the player will move (pixels/sec).
@onready var BloodParticle: GPUParticles2D = get_node("ParticleInterface/BloodParticle")
@onready var Arrow: GPUParticles2D = get_node("ArrowInterface/GPUParticles2D")
var startpos = Vector2.ZERO
var life = maxlife
var screen_size # Size of the game window.
var i = 0
var player_chase = false
var player_attack = false
var player = null
var frame_alt = 0
var frame_neu = 0

func _physics_process(delta):
	
	$HPbar.set_value_no_signal(life*100/maxlife)
	
	if player_attack and player != null:
		
		velocity = Vector2.ZERO
		if abs(player.position.x - position.x) < 10:
			if abs(player.position.y - position.y) < 10:
				$AnimatedSprite2D.animation = "shot_right"
			elif player.position.y - position.y < 0:
				$AnimatedSprite2D.animation = "shot_top"
			else:
				$AnimatedSprite2D.animation = "shot_bot"
		elif (player.position.x - position.x) > 0:
			if abs(player.position.y - position.y) < 10:
				$AnimatedSprite2D.animation = "shot_right"
			elif player.position.y - position.y < 0:
				$AnimatedSprite2D.animation = "shot_top_right"
			else:
				$AnimatedSprite2D.animation = "shot_bot_right"
		else:
			if abs(player.position.y - position.y) < 10:
				$AnimatedSprite2D.animation = "shot_right"
			elif player.position.y - position.y < 0:
				$AnimatedSprite2D.animation = "shot_top_right"
			else:
				$AnimatedSprite2D.animation = "shot_bot_right"
			$AnimatedSprite2D.flip_h = true
		if player.life <= 0:
			player.hide()
			player_attack = false
			player_chase = false
			player = null
		$AnimatedSprite2D.play()
		frame_neu = $AnimatedSprite2D.frame
		if frame_alt != frame_neu && frame_neu == 6:
			# && player != null:
			if player.life != null:
				player.life -= 100
			player.BloodParticle.emitting = true
			var blood_direction = Vector3.ZERO
			var arrow_lifetime = 0
			var arrow_rotation = 0
			blood_direction.x = player.position.x - position.x
			blood_direction.y = player.position.y - position.y
			arrow_lifetime = sqrt(pow(blood_direction.x,2) + pow(blood_direction.y,2))
			arrow_lifetime /= 800. # lifetime, 800 = velocity of arrows
			if arrow_lifetime > 0.3: # cutoff so arrow always disappears
				arrow_lifetime = 0.3
			arrow_rotation = sqrt(pow(blood_direction.x,2) + pow(blood_direction.y,2))
			arrow_rotation = acos(blood_direction.x/arrow_rotation)
			if blood_direction.y > 0:
				arrow_rotation = (-1.0)*arrow_rotation * 360. / (2.*PI)
			elif blood_direction.x > 0:
				arrow_rotation = (1.0)*arrow_rotation * 360. / (2.*PI)#(-1.0)*arrow_rotation * 360. / (2.*PI)
			elif blood_direction.x < 0:
				arrow_rotation = -180-((-1.0)*arrow_rotation * 360. / (2.*PI) + 180.)
	
			player.init_bloodparticles(blood_direction)
			init_arrowparticles(blood_direction, arrow_lifetime, arrow_rotation)
			Arrow.emitting = true
			print(arrow_rotation)
			#print(acos(arrow_rotation) * 360. / (2.*PI), " ", acos(arrow_rotation)* 360. / (2.*PI), " ",atan(arrow_rotation)* 360. / (2.*PI))
			
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


func init_bloodparticles(direction : Vector3):
	BloodParticle.get_process_material().direction = direction
	
func init_arrowparticles(direction : Vector3, lifetime, arrow_rotation):
	Arrow.get_process_material().direction = direction
	Arrow.lifetime = lifetime
	Arrow.get_process_material().angle_min = arrow_rotation
	Arrow.get_process_material().angle_max = arrow_rotation
	#Arrow.rotation = arrow_rotation

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	
func _on_attack_area_body_entered(body):
	player = body
	player_attack = true
	player_chase = false

func _on_attack_area_body_exited(body):
	player_attack = false
	player_chase = true
