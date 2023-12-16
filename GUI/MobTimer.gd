extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.Player.score >= 1000:
		wait_time = 10.0
	if Global.Player.score >= 2000:
		wait_time = 5.0
	
