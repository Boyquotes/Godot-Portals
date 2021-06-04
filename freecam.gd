extends Spatial

export(float) var move_speed = 1.0

var mouse_target = null
var player = null
var camera = null
var camera_pivot = null
 
func _ready():
	# Get camera
	camera = get_node(".");
	return
 

# MOUSE
var mouse_buttons = [0, 0, 0]
var mouse_pos_temp = Vector2()

func _input(event):
	mouse_buttons[2] = 0
   
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == 2:
				mouse_buttons[1] = 1
				mouse_pos_temp = get_viewport().get_mouse_position()
			if event.button_index == BUTTON_WHEEL_UP:
				mouse_buttons[2] = 1
			if event.button_index == BUTTON_WHEEL_DOWN:
				mouse_buttons[2] = 2
		else:
			mouse_buttons[1] = 0
 
	if mouse_buttons[1] == 1:
		var mouse_delta = Vector2(mouse_pos_temp[0]-get_viewport().get_mouse_position()[0],
								  mouse_pos_temp[1]-get_viewport().get_mouse_position()[1])
	   
		# Horizontal rotation
		var target_rot = camera.get_rotation()
		target_rot.y += 0.005*mouse_delta.x
		camera.set_rotation(target_rot)
	   
		# Vertical rotation
		target_rot = camera.get_rotation()
		target_rot.x += 0.003*mouse_delta.y
	   
		if target_rot.x > 1.4:
			target_rot.x = 1.4
		elif target_rot.x < -1.4:
			target_rot.x = -1.4
		camera.set_rotation(target_rot)
	   
		get_viewport().warp_mouse(mouse_pos_temp)
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	return		   
		   
 
func _process(delta):
	var target_speed = Vector3()
	if Input.is_key_pressed(KEY_W):
		 target_speed -= get_transform().basis.z
	if Input.is_key_pressed(KEY_S):
		 target_speed += get_transform().basis.z
	if Input.is_key_pressed(KEY_A):
		 target_speed -= get_transform().basis.x
	if Input.is_key_pressed(KEY_D):
		 target_speed += get_transform().basis.x
	if Input.is_key_pressed(KEY_SPACE):
		 target_speed += Vector3.UP
	if Input.is_key_pressed(KEY_C):
		 target_speed -= Vector3.UP
		
	camera.translation += target_speed.normalized() * (move_speed + (int(Input.is_key_pressed(KEY_SHIFT))*2)) * (delta * 1)
	
	return
