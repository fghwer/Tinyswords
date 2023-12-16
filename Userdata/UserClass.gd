extends Node
# USER

class_name  User

var gold = null
var life = null
var level = 1
var score = null


func _init():
	print("user erstellt")
	self.gold = 100
	self.life = 3
	self.score = 0
	self.life = 0
