extends KinematicBody2D

onready var Player = get_parent().get_node("Player")
var vel = Vector2(0, 0)

var velocity = 500
var grav = 1800
var max_grav = 3000

var react_time = 50

# horizontal moviment
var direction = 0
var next_direction = 0 
var next_direction_time = 0
var target_player_distance_x = 100

# vertical moviment
var target_player_distance_y = 50
var next_jump_time = -1

func _ready():
	set_process(true)
	
func _process(delta):
	if Player.position.x < position.x - target_player_distance_x:
		set_direction(-1)
	elif Player.position.x > position.x + target_player_distance_x:
		set_direction(1)
	else:
		set_direction(0)
	
	if Player.position.y < position.y - target_player_distance_y and next_jump_time == -1 and is_on_floor():
		next_jump_time = OS.get_ticks_msec() + react_time
		
	if OS.get_ticks_msec() > next_direction_time:
		direction = next_direction

	if OS.get_ticks_msec() > next_jump_time and next_jump_time != -1 and is_on_floor():
		if Player.position.y < position.y - target_player_distance_y:
			vel.y = -900
		next_jump_time = -1

	vel.x = direction * velocity
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
		
