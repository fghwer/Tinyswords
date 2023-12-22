extends StaticBody2D

var active_trigger = false
@onready var BloodParticle: GPUParticles2D = get_node("ParticleInterface/BloodParticle")
@onready var Wood: AnimatedSprite2D = get_node("WoodSpawn/Wood")
@export var maxlife = 1000.
var life = maxlife
var interact_trigger = false
var player = null
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
	#if interact_trigger and player != null:
		#if player.name == "worker_wood":
		#	if player.$AnimatedSprite2D.frame == 4:
		


#func _on_interact_area_body_entered(_body):
#	if interact_trigger:
#		pass
#	else:
#		#print("active")
#		interact_trigger = true
#		$WoodSpawn.visible = true
#		Wood.play()



func _on_interact_area_area_entered(area):
	if interact_trigger:
		pass
	else:
		#print("active")
		interact_trigger = true
		$WoodSpawn.visible = true
		Wood.play()
