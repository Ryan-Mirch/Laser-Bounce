# Licensed under the MIT License.
# Copyright (c) 2018 Jaccomo Lorenz (Maujoe)

extends Camera

# User settings:
# General settings
export var enabled = true setget set_enabled
export(int, "Visible", "Hidden", "Caputered, Confined") var mouse_mode = 2

# Mouslook settings
export var mouselook = true
export (float, 0.0, 1.0) var sensitivity = 0.5
export (float, 0.0, 0.999, 0.001) var smoothness = 0.5 setget set_smoothness
export(NodePath) var pivot setget set_pivot
export var min_distance = 1
export var max_distance = 10
export var distance = 5.0 setget set_distance
export var rotate_pivot = false
export var collisions = true setget set_collisions
export (int, 0, 360) var yaw_limit = 360
export (int, 0, 360) var pitch_limit = 360
export (int, 0, 90) var pitch_offset = 0


# Intern variables.
var _mouse_position = Vector2(0.0, 0.0)
var _yaw = 0.0
var _pitch = 0.0
var _total_yaw = 0.0
var _total_pitch = 0.0

var rayOrigin = Vector3()
var rayEnd = Vector3()

var _pressed = false


func _ready():

	if pivot:
		pivot = get_node(pivot)
	else:
		pivot = null

	set_enabled(enabled)

func _input(event):

	if event.is_action_pressed("grab"):
		if Camera_Pannable():			
			_pressed = true
	
	if event.is_action_released("grab"):
		_pressed = false

	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				distance -= distance/5				

			elif event.button_index == BUTTON_WHEEL_DOWN:
				distance += distance/5

			distance = clamp(distance, min_distance, max_distance)	

	if mouselook:
		if event is InputEventMouseMotion:
			if _pressed:
				_mouse_position = event.relative
				
func Camera_Pannable():
	var space_state = get_world().get_direct_space_state()
	var mouse_position = get_viewport().get_mouse_position()
	rayOrigin = project_ray_origin(mouse_position)
	rayEnd = rayOrigin + project_ray_normal(mouse_position)*2000
	
	var intersection = space_state.intersect_ray(rayOrigin, rayEnd)
	
	if intersection.empty():
		return true
	
	if intersection.collider.is_in_group("Plane"):
		return true
	
	return false
	

func _process(_delta):
	if pivot:
		_update_distance()
	if mouselook:
		_update_mouselook()
	_update_Global_Pointer_Trans()

func _physics_process(_delta):
	# Called when collision are enabled
	_update_distance()
	if mouselook:
		_update_mouselook()

	var space_state = get_world().get_direct_space_state()
	var obstacle = space_state.intersect_ray(pivot.get_translation(),  get_translation())
	if not obstacle.empty():
		set_translation(obstacle.position)
	
		
func _update_Global_Pointer_Trans():
	
	var space_state = get_world().get_direct_space_state()
	var mouse_position = get_viewport().get_mouse_position()
	rayOrigin = project_ray_origin(mouse_position)
	rayEnd = rayOrigin + project_ray_normal(mouse_position)*2000
	
	var intersection = space_state.intersect_ray(rayOrigin, rayEnd,[],2)
	
	if not intersection.empty():
		Global.pointerTranslation = intersection.position

func _update_mouselook():
	_mouse_position *= sensitivity
	_yaw = _yaw * smoothness + _mouse_position.x * (1.0 - smoothness)
	_pitch = _pitch * smoothness + _mouse_position.y * (1.0 - smoothness)
	_mouse_position = Vector2(0, 0)

	if yaw_limit < 360:
		_yaw = clamp(_yaw, -yaw_limit - _total_yaw, yaw_limit - _total_yaw)
	if pitch_limit < 360:
		_pitch = clamp(_pitch, (-pitch_limit - _total_pitch) + pitch_offset, (pitch_limit - _total_pitch) + pitch_offset)

	_total_yaw += _yaw
	_total_pitch += _pitch

	if pivot:
		var target = pivot.get_translation()
		var offset = get_translation().distance_to(target)

		set_translation(target)
		rotate_y(deg2rad(-_yaw))
		rotate_object_local(Vector3(1,0,0), deg2rad(-_pitch))
		translate(Vector3(0.0, 0.0, offset))

		if rotate_pivot:
			pivot.rotate_y(deg2rad(-_yaw))
	else:
		rotate_y(deg2rad(-_yaw))
		rotate_object_local(Vector3(1,0,0), deg2rad(-_pitch))

func _update_distance():
	var t = pivot.get_translation()
	t.z -= distance
	set_translation(t)

func _update_process_func():
	# Use physics process if collision are enabled
	if collisions and pivot:
		set_physics_process(true)
		set_process(false)
	else:
		set_physics_process(false)
		set_process(true)

func _check_actions(actions=[]):
	if OS.is_debug_build():
		for action in actions:
			if not InputMap.has_action(action):
				print('WARNING: No action "' + action + '"')

func set_pivot(value):
	pivot = value
	_update_process_func()

func set_collisions(value):
	collisions = value
	_update_process_func()

func set_enabled(value):
	enabled = value
	if enabled:
		Input.set_mouse_mode(mouse_mode)
		set_process_input(true)
		_update_process_func()
	else:
		set_process(false)
		set_process_input(false)
		set_physics_process(false)

func set_smoothness(value):
	smoothness = clamp(value, 0.001, 0.999)

func set_distance(value):
	distance = max(0, value)
	

	
