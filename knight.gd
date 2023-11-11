extends CharacterBody2D



signal hit 
@export var life = 3000
@export var speed = 100 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var i = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if life <= 0:
		hide()
	
	var velocity = Vector2.ZERO # The player's movement vector.
	#var i = 0
	#if Input.is_action_pressed("move_right"):
	i += 1
	if i == 720:
		i = 0
	#print(i)
	velocity.x = cos((PI/360)*i)
	velocity.y = sin((PI/360)*i) 
	
	velocity *= speed
	#print(velocity.x)
	
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
		#velocity = velocity.normalized() * speed
	
	$AnimatedSprite2D.play()
	
	position += velocity * delta
	
	move_and_slide()
	#print(position)
	#position = position.clamp(Vector2(386,146), Vector2(834,466))
		#$AnimatedSprite2D.play()
	#else:
	#	$AnimatedSprite2D.stop()


#func _on_body_entered(body):
#	hit.emit()
	#position -=
	#velocity = Vector2.ZERO

