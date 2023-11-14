extends CharacterBody2D

signal hit 
@export var maxlife = 1000
@export var speed = 100 # How fast the player will move (pixels/sec).
var life = maxlife
var screen_size # Size of the game window.
var i = 0
var player_chase = false
var player_attack = false
var player = null
var frame_alt = 0
var frame_neu = 0

const SPEED = 50.0
#const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(_delta):
	
	var hpper = life/maxlife
	#var velocity = Vector2.ZERO # The player's movement vector.
	$HPbar.set_value_no_signal(life*100/maxlife)
	#velocity = Vector2(100,100)
	#if velocity.length() > 0:
		#velocity = velocity.normalized() * speed
	#$AnimatedSprite2D.animation = "walk"
	#$AnimatedSprite2D.play()
	
	#position += velocity * delta
	
	#move_and_slide()
	if player_attack and player != null:
		#var frame_alt = 0
		#var frame_neu = 0
		#print("attack")
		
		#if frame_alt != frame_neu && frame_neu == 3:
		#	player.life -= 100
		velocity = Vector2.ZERO
		$AnimatedSprite2D.animation = "attack"
		#frame_alt = $AnimatedSprite2D.frame
		#print(frame_neu)
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
		if frame_alt != frame_neu && frame_neu == 4 && life > 0:
			player.life -= 300
			if player.life <= 0:
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
	elif player != null and (player.position.x - position.x)^2 + (player.position.y - position.y)^2  > 20:
		velocity = (player.position - position).normalized()*speed
		if(player.position.x -position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play()
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.flip_h = false
		#if navigation_agent.is_navigation_finished():
		#	return
		#if i_nav == 0:
		#var target_position: Vector2 = navigation_agent.target_position
		#var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		#var current_agent_position: Vector2 = navigation_agent.get_parent().position
		#next_path_position -= current_agent_position
		#var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized() * speed
		#velocity = new_velocity
		#print(target_position, current_agent_position, next_path_position)
		#if velocity == Vector2.ZERO:
			#$AnimatedSprite2D.animation = "idle"
			#$AnimatedSprite2D.flip_h = false
		#elif velocity.x > 0:
			#$AnimatedSprite2D.animation = "walk"
			#$AnimatedSprite2D.flip_h = false
		#elif velocity.x < 0:
			#$AnimatedSprite2D.animation = "walk"
			#$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play()
	#i_nav = 100
	#i_nav -=1
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = 1#Input.get_axis("ui_left", "ui_right")
	#if direction:
	#velocity.x = direction * speed
	#velocity.y = direction * speed
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	
func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	
func _on_attack_area_body_entered(body):
	player = body
	player_attack = true
	player_chase = false
	
func _on_attack_area_body_exited(body):
	player_attack = false
	player_chase = true
