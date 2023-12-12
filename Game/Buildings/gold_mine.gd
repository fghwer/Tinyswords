extends StaticBody2D

var active_trigger = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if active_trigger == true:
		$MineSprite.animation = "active"
		
	elif active_trigger == false:
		$MineSprite.animation = "inactive"


func _on_active_area_body_entered(_body):
	active_trigger = true
	


func _on_active_area_body_exited(_body):
	active_trigger = false
