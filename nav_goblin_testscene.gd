extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$navigation_goblin.set_movement_target($Marker2D.position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
