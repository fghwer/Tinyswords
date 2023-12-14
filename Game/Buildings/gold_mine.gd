extends StaticBody2D

var active_trigger = false
@onready var BloodParticle: GPUParticles2D = get_node("ParticleInterface/BloodParticle")
@export var maxlife = 1000.
var life = maxlife
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print(active_trigger)
	if active_trigger == true:
		$MineSprite.animation = "active"
		
	elif active_trigger == false:
		$MineSprite.animation = "inactive"



func _on_active_area_area_entered(area):
	#print("active")
	active_trigger = true
	

func _on_active_area_area_exited(area):
	#print("inactive")
	active_trigger = false	
