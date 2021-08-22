extends KinematicBody2D

onready var Player = get_parent().get_node("Player")
var vel = Vector2(0, 0)

var velocity = 500
var grav = 1800
var max_grav = 3000

var react_time = 400
var direction = 0
var next_direction = 0 
var next_direction_time = 0
var target_player_distance = 100

func _ready():
	set_process(true)
	
func _process(delta):
	if Player.position.x < position.x - target_player_distance:
		set_direction(-1)
	elif Player.position.x > position.x + target_player_distance:
		set_direction(1)
	else:
		set_direction(0)
	
	if OS.get_ticks_msec() > next_direction_time:
		direction = next_direction

	vel.x = direction * velocity
#	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
#		vel.y = -800
		
	vel.y += grav * delta
	
	if vel.y > max_grav:
		vel.y = max_grav
		
	if vel.y > 0 and is_on_floor():
		vel.y = 0
	
	vel = move_and_slide(vel, Vector2(0, -1))

func set_direction(target_direction):
	if next_direction != target_direction:
		next_direction = target_direction
		next_direction_time = OS.get_ticks_msec() + react_time
		
