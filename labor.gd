extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#$foam_top_border.play()
	#$TileMapFoam.play()
	for _i in $Foam_Animation_Parent.get_children():
		_i.play()


#func _on_button_pressed():
#	var player = "res://area_2d.tscn"
#	player.instantiate()
#	add_child(player)
#	print("player created")
	
#	pass # Replace with function body.
