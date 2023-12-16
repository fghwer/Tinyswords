extends StaticBody2D

var active_trigger = false
@onready var BloodParticle: GPUParticles2D = get_node("ParticleInterface/BloodParticle")
@onready var Wood: AnimatedSprite2D = get_node("WoodSpawn/Wood")
@export var maxlife = 1000.
var life = maxlife
var interact_trigger = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation = "default"
	$WoodSpawn.visible = false
	Wood.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $WoodSpawn.visible == true and Wood.frame == 6:
		$WoodSpawn.visible = false
		interact_trigger = false
		Wood.stop()


func _on_interact_area_body_entered(body):
	if interact_trigger:
		pass
	else:
		#print("active")
		interact_trigger = true
		$WoodSpawn.visible = true
		Wood.play()
