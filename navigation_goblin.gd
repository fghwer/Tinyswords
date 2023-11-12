extends CharacterBody2D


@export var speed = 200 # How fast the player will move (pixels/sec).
@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")
var screen_size # Size of the game window.
var i_nav=0

func _ready():
	screen_size = get_viewport_rect().size
	#navigation_agent.set_target_position(Vector2(1000,1000))

func set_movement_target(movement_target: Vector2):
	navigation_agent.set_target_position(movement_target)

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(_delta):
	
	if navigation_agent.is_navigation_finished():
		return
	#if i_nav == 0:
	var target_position: Vector2 = navigation_agent.target_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var current_agent_position: Vector2 = navigation_agent.get_parent().position
	#next_path_position -= current_agent_position
	var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized() * speed
	velocity = new_velocity
	print(target_position, current_agent_position, next_path_position)
	#i_nav = 100
	#i_nav -=1
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = 1#Input.get_axis("ui_left", "ui_right")
	#if direction:
	#velocity.x = direction * speed
	#velocity.y = direction * speed
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
