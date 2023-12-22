extends StaticBody2D

@onready var Explosion: AnimatedSprite2D = get_node("Explosion/Explosion")
@onready var Fire1: AnimatedSprite2D = get_node("Fire1/Fire")
@onready var Fire2: AnimatedSprite2D = get_node("Fire2/Fire")
@onready var BloodParticle: GPUParticles2D = get_node("ParticleInterface/BloodParticle")
@export var maxlife = 1000.
var life = maxlife
var trigger_fire1 = false
var trigger_fire2 = false
var startpos = Vector2.ZERO
var trigger_dead = false

#var timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$TowerSprite.animation = "default"
	$Explosion.visible = false
	Explosion.stop()
	$Fire1.visible = false 
	$Fire2.visible = false 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	life -= 1
	
	if life < maxlife * 0.50 and not trigger_fire1:
		$Fire1.visible = true
		Fire1.animation = "burn"
		Fire1.play()
		trigger_fire1 = true
	elif life < maxlife * 0.25 and not trigger_fire2:
		$Fire2.visible = true
		Fire2.animation = "burn"
		Fire2.play()
		trigger_fire2 = true
	
	elif life <= 0 and $TowerSprite.animation == "default" and not trigger_dead:
		
		$Fire1.visible = false
		$Fire2.visible = false
		
		$Explosion.visible = true
		Explosion.animation = "default"
		Explosion.play()
		Global.Player.populationMax -= 10
		
		$TowerSprite.animation = "destroy"
		
		trigger_dead = true
		
	if trigger_dead and Explosion.frame == 8:
		pass
		
		

func init_bloodparticles(direction : Vector3):
	BloodParticle.get_process_material().direction = direction
	


