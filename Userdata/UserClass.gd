extends Node
# USER

class_name  User

var gold = null
var life = null
var level = null
var score = null
var populationMax = null
var population = null


func _init():
	print("user erstellt")
	self.gold = 100
	self.life = 3
	self.level = 1
	self.score = 0
	self.life = 0
	self.population = 0
	self.populationMax = 10
