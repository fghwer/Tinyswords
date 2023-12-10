extends Node
# USER

class_name  User

var score = "" # string or int? 
var gold = null
var life = null


func _init():
	print("user erstellt")
	self.gold = 3
	self.life = 3
