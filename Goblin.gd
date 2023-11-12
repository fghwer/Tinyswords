extends CharacterBody2D

@export var speed = 100 # How fast the player will move (pixels/sec).
@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")
var screen_size # Size of the game window.
var i = 0
var i_nav = 0
var player = null
var player_chase = false
var player_attack = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(navigation_agent)
	screen_size = get_viewport_rect().size
	#navigation_agent.set_target_position(Vector2(1000,250))
# Called every frame. 'delta' is the elapsed time since the previous frame.

func set_movement_target(movement_target: Vector2):
	navigation_agent.set_target_position(movement_target)


func _physics_process(delta):
	#print(navigation_agent)
	
	if player_attack:
		print("attack")
		player.life -= 100
		$AnimatedSprite2D.play("attack")
		if(player.position.x -position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false	
			
	elif player_chase:
		print("chase")
		position +=(player.position - position)/speed
		$AnimatedSprite2D.play("walk")
		if(player.position.x -position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
			
	
	else:
		#movement_target = Vector2(1000, 250)
		#set_movement_target(Vector2(1000, 250))
		idle_navigation(delta)
		#print
		#if i_nav == 0:
		#	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		#	var current_agent_position: Vector2 = global_position
		#	var velocity: Vector2 = (next_path_position - current_agent_position).normalized() * speed
		#	i_nav = 100
		#i_nav -=1
	

func idle(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	#var i = 0
	#if Input.is_action_pressed("move_right"):
	i += 1
	if i == 720:
		i = 0
	#print(i)
	velocity.x = cos((PI/360)*i)
	velocity.y = sin((PI/360)*i) 
	
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.flip_h = false
	elif velocity.x > 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = true
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	$AnimatedSprite2D.play()
	
	position += velocity * delta
	
	move_and_slide()
	#position = position.clamp(Vector2.ZERO, screen_size)
		#$AnimatedSprite2D.play()
	#else:
	#	$AnimatedSprite2D.stop()

func idle_navigation(delta):
	
	#if i_nav == 0:
	var target_position: Vector2 = navigation_agent.target_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var current_agent_position: Vector2 = navigation_agent.get_parent().position
	var velocity: Vector2 = (next_path_position - current_agent_position).normalized() * speed
	#	i_nav = 100
	print(target_position, current_agent_position, next_path_position)
	#i_nav -=1
	
	#var velocity = Vector2.ZERO # The player's movement vector.
	#var i = 0
	#if Input.is_action_pressed("move_right"):
	#i += 1
	#if i == 720:
	#	i = 0
	#print(i)
	#velocity.x = cos((PI/360)*i)
	#velocity.y = sin((PI/360)*i) 
	
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.flip_h = false
	elif velocity.x > 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = true
		
	#if velocity.length() > 0:
	#	velocity = velocity.normalized() * speed
	
	$AnimatedSprite2D.play()
	
	position += velocity * delta
	
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
