extends StaticBody2D

@onready var Explosion: AnimatedSprite2D = get_node("Explosion/Explosion")
@onready var Fire1: AnimatedSprite2D = get_node("Fire1/Fire")
@onready var Fire2: AnimatedSprite2D = get_node("Fire2/Fire")
@onready var Fire3: AnimatedSprite2D = get_node("Fire3/Fire")
@onready var BloodParticle: GPUParticles2D = get_node("ParticleInterface/BloodParticle")
@export var maxlife = 1000.
var life = maxlife
var trigger_fire1 = false
var trigger_fire2 = false
var trigger_fire3 = false
var trigger_dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$CastleSprite.animation = "default"
	$Explosion.visible = false
	Explosion.stop()
	$Fire1.visible = false 
	$Fire2.visible = false
	$Fire3.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#life -= 1
	#print(life/maxlife)
	#print(Explosion.frame)
	
	if life < maxlife * 0.75 and not trigger_fire1:
		$Fire1.visible = true
		Fire1.animation = "burn"
		Fire1.play()
		trigger_fire1 = true
	elif life < maxlife * 0.50 and not trigger_fire2:
		$Fire2.visible = true
		Fire2.animation = "burn"
		Fire2.play()
		trigger_fire2 = true
	elif life < maxlife * 0.25 and not trigger_fire3:
		$Fire3.visible = true
		Fire3.animation = "burn"
		Fire3.play()
		trigger_fire3 = true
	elif life <= 0 and $CastleSprite.animation == "default" and not trigger_dead:
		
		$Fire1.visible = false
		$Fire2.visible = false
		$Fire3.visible = false
		
		$Explosion.visible = true
		Explosion.animation = "default"
		Explosion.play()
		
		$CastleSprite.animation = "destroy"
		
		trigger_dead = true

func init_bloodparticles(direction : Vector3):
	BloodParticle.get_process_material().direction = direction
