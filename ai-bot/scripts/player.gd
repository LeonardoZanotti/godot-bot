extends KinematicBody2D

var vel = Vector2(0, 0)

var grav = 1800
var max_grav = 3000

func _ready():
	set_process(true)
	
func _process(delta):
	if Input.is_key_pressed(KEY_A):
		vel.x = -500
	elif Input.is_key_pressed(KEY_D):
		vel.x = 500
	else:
		vel.x = 0
	
	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		vel.y = -800
		
	vel.y += grav * delta
	
	if vel.y > max_grav:
		vel.y = max_grav
		
	if vel.y > 0 and is_on_floor():
		vel.y = 0
	
	vel = move_and_slide(vel, Vector2(0, -1))
