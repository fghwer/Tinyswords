extends CharacterBody2D


@export var speed = 125 # How fast the player will move (pixels/sec).
@export var maxlife = 1000.
@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")
@onready var BloodParticle: GPUParticles2D = get_node("ParticleInterface/BloodParticle")
var life = maxlife
var screen_size # Size of the game window.
var i_nav=0
var player_chase = false
var player_attack = false
var player = null
var frame_alt = 0
var frame_neu = 0

func _ready():
	screen_size = get_viewport_rect().size
	$HPbar.set_value_no_signal(100)
	#navigation_agent.set_target_position(Vector2(608,296))
	#BloodParticle.get_process_material().direction = Vector3(0,1,0)
	#print(BloodParticle.get_process_material().direction)
	


func _physics_process(_delta):
	#print(player)
	
	if player_attack and player != null:
		#print(player.name == "BaseCastle")
		#var frame_alt = 0
		#var frame_neu = 0
		#print("attack")
		#var hpper = life/maxlife
		#var velocity = Vector2.ZERO # The player's movement vector.
		$HPbar.set_value_no_signal(life*100/maxlife)
		#if frame_alt != frame_neu && frame_neu == 3:
		#	player.life -= 100
		velocity = Vector2.ZERO
		if abs(player.position.x - position.x) >= abs(player.position.y - position.y):
			$AnimatedSprite2D.animation = "attack"
		elif (player.position.y < position.y):
			$AnimatedSprite2D.animation = "attack_top"
		else:
			$AnimatedSprite2D.animation = "attack_bot"
		#$AnimatedSprite2D.animation = "attack"
		#frame_alt = $AnimatedSprite2D.frame
		#print(frame_neu)
		if(player.position.x - position.x) < 0: # player ist knight
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		if player.life <= 0:
			#player.hide()
			player_attack = false
			player_chase = false
			player = null
		$AnimatedSprite2D.play()
		frame_neu = $AnimatedSprite2D.frame
		if frame_alt != frame_neu && frame_neu == 3 && life > 0:
			#pass
			player.life -= 50
			
			#if player != "BaseCastle":
			player.BloodParticle.emitting = true
			var blood_direction = Vector3.ZERO
			blood_direction.x = player.position.x - position.x
			blood_direction.y = player.position.y - position.y
			player.init_bloodparticles(blood_direction)
			#player.BloodParticle.direction = Vector3(0,1,0)
			if player.life <= 0 and player.name != "BaseCastle":
				player.queue_free()
				
			#player.set_hpbar_value(player.life/player.maxlife)
			#print(player, player.life)
		#print(player)
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
	else:
		if navigation_agent.is_navigation_finished():
			return
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

func init_bloodparticles(direction : Vector3):
	BloodParticle.get_process_material().direction = direction
	
func init_target_position(navigation_target_pos : Vector2):
	$NavigationAgent2D.set_target_position(navigation_target_pos)

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
