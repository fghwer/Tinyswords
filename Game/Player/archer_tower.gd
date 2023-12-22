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

func _physics_process(_delta):
	
	#$ProgressBar.set_value_no_signal(life*100/maxlife)
	
	if player_attack:
		if player != null:
		
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
			if frame_alt != frame_neu && frame_neu == 6 && player != null:
				# && player != null::
				if player.life != null:
					if player.life > 0:
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
				#print(arrow_rotation)
				#print(acos(arrow_rotation) * 360. / (2.*PI), " ", acos(arrow_rotation)* 360. / (2.*PI), " ",atan(arrow_rotation)* 360. / (2.*PI))
				
				if player.life <= 0:
					Global.Player.score += 100
					player.queue_free()
					#$attack_area.get_overlapping_bodies()
					var i_olb = 0
					for _i in $attack_area.get_overlapping_bodies():
						i_olb += 1
						#print(i_olb, _i)
						var smallest_dist_i = 1000000. # just larger value than all distances
						if _i != null and i_olb != 1: # i_olb is 1 for first list element (which is old, dead player - not updated when player dies)
							var dist_i = 0 
							dist_i = sqrt(pow(position.x - _i.position.x,2) + pow(position.y - _i.position.y,2))
							if dist_i < smallest_dist_i:
								smallest_dist_i = dist_i
								player = _i
					if i_olb <=1:
						player = null
						player_attack = false
						player_chase = true
					else:
						print("archer: on-kill attack_target_changed")
						player_attack = false
						_on_attack_area_body_entered(player)
					#i_olb = 0
					#print(player,i_olb)
					#print($attack_area.get_overlapping_bodies())
					
				#player.set_hpbar_value(player.life/player.maxlife)
				#print(player, player.life)
			#print(frame_alt,frame_neu)
			frame_alt = frame_neu
		else:
			#var i_olb = 0
			for _i in $attack_area.get_overlapping_bodies():
			#	i_olb += 1
				#print(i_olb, _i)
				var smallest_dist_i = 1000000. # just larger value than all distances
				if _i != null:# and i_olb != 1: # i_olb is 1 for first list element (which is old, dead player - not updated when player dies)
					var dist_i = 0 
					dist_i = sqrt(pow(position.x - _i.position.x,2) + pow(position.y - _i.position.y,2))
					if dist_i < smallest_dist_i:
						smallest_dist_i = dist_i
						player = _i
			#if i_olb <=1:
				#player = null
			if player != null:
				print("archer: attack target changed")
				player_attack = false
				_on_attack_area_body_entered(player)
			else: 
				player_attack = false
				player_chase = true
			#i_olb = 0
	

	

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
	if player_attack == true or player_chase == true:
		pass
	else:
		player = body
		player_chase = true
	
func _on_detection_area_body_exited(_body):
	#var i_olb = 0
	var other_player_in_area = false
	for _i in $detection_area.get_overlapping_bodies():
		#i_olb += 1
		#print(i_olb, _i)
		#var smallest_dist_i = 1000000. # just larger value than all distances
		if _i != null:# and i_olb != 1: # i_olb is 1 for first list element (which is old, dead player - not updated when player dies)
			other_player_in_area = true
	if other_player_in_area:		
		pass
	else:
		player = null
		player_chase = false
	
func _on_attack_area_body_entered(body):
	if player_attack == true:
		pass
	else:
		#if player == null:
		player = body
			#player_attack = true
			#player_chase = false
		#else:
		#	pass
		player_attack = true
		player_chase = false

func _on_attack_area_body_exited(_body):
	var other_player_in_area = false
	for _i in $attack_area.get_overlapping_bodies():
		#i_olb += 1
		#print(i_olb, _i)
		#var smallest_dist_i = 1000000. # just larger value than all distances
		if _i != null:# and i_olb != 1: # i_olb is 1 for first list element (which is old, dead player - not updated when player dies)
			other_player_in_area = true
	if other_player_in_area:		
		pass
	else:
		player_attack = false
		player_chase = true #fixen



