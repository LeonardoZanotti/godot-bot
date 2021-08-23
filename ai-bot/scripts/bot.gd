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

# eye
var eye_reach = 90
var vision = 320

func _ready():
	set_process(true)
	
func _process(delta):
	if Player.position.x < position.x - target_player_distance_x and sees_player():
		set_direction(-1)
	elif Player.position.x > position.x + target_player_distance_x and sees_player():
		set_direction(1)
	else:
		set_direction(0)
	
	if Player.position.y < position.y - target_player_distance_y and next_jump_time == -1 and is_on_floor() and sees_player():
		next_jump_time = OS.get_ticks_msec() + react_time
		
	if OS.get_ticks_msec() > next_direction_time:
		direction = next_direction

	if OS.get_ticks_msec() > next_jump_time and next_jump_time != -1 and is_on_floor():
		if Player.position.y < position.y - target_player_distance_y and sees_player():
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
		
func sees_player():
	var eye_center = get_global_position()
	var eye_top = Vector2(0, -eye_reach)
	var eye_left = Vector2(-eye_reach, 0)
	var eye_right = Vector2(eye_reach, 0)
	
	var player_position = Player.get_global_position()
	var player_extents = Player.get_node("CollisionShape2D").shape.extents - Vector2(1, 1)
	
	var top_left = player_position + Vector2(-player_extents.x, -player_extents.y)
	var top_right = player_position + Vector2(player_extents.x, -player_extents.y)
	var bottom_left = player_position + Vector2(-player_extents.x, player_extents.y)
	var bottom_right = player_position + Vector2(player_extents.x, player_extents.y)

	var space_state = get_world_2d().direct_space_state
	
	for eye in [eye_center, eye_top, eye_left, eye_right]:
		for corner in [top_left, top_right, bottom_left, bottom_right]:
			if eye.distance_to(corner) > vision:
				continue
			var collision = space_state.intersect_ray(eye, corner, [self], 1)
			if (collision and collision.collider.name == "Player") or eye.distance_to(corner) < vision:
				return true
	return false
