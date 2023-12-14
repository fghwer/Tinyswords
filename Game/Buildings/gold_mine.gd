extends StaticBody2D

var active_trigger = false
@onready var BloodParticle: GPUParticles2D = get_node("ParticleInterface/BloodParticle")
@onready var Gold: AnimatedSprite2D = get_node("GoldSpawn/Gold")
@export var maxlife = 1000.
var life = maxlife
# Called when the node enters the scene tree for the first time.
func _ready():
	$GoldSpawn.visible = false
	Gold.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $GoldSpawn.visible == true and Gold.frame == 6:
		$GoldSpawn.visible = false
		Gold.stop()
	#print(active_trigger)
	if active_trigger == true:
		$MineSprite.animation = "active"
		
	elif active_trigger == false:
		$MineSprite.animation = "inactive"



func _on_active_area_area_entered(_area):
	#print("active")
	active_trigger = true
	$GoldSpawn.visible = true
	Gold.play()

func _on_active_area_area_exited(_area):
	#print("inactive")
	active_trigger = false
	#$GoldSpawn.visible = true
	#Gold.play()
