extends CharacterBody2D

@export var speed = 100 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var i = 0
var player = null
var player_chase = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	
	if player_chase:
		position +=(player.position - position)/speed
		
		$AnimatedSprite2D.play("attack")
		
		if(player.position.x -position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
	else:
		idle(delta)
	

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


func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
