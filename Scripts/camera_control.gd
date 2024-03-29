# Licensed under the MIT License.
# Copyright (c) 2018 Jaccomo Lorenz (Maujoe)

extends Camera

# User settings:
# General settings
export var enabled = true setget set_enabled
export(int, "Visible", "Hidden", "Caputered, Confined") var mouse_mode = 2

# Mouslook settings
export var mouselook = true
export (float, 0.0, 0.999, 0.001) var smoothness = 0.5 setget set_smoothness
var pivot 
var min_distance = 15
var max_distance = 50
export var distance = 5.0 setget set_distance
export var rotate_pivot = false
export var collisions = true setget set_collisions
export (int, 0, 360) var yaw_limit = 360
#export (int, 0, 360) var pitch_limit = 360
export (int, 0, 360) var upper_pitch_limit = 360
export (int, 0, 360) var lower_pitch_limit = 360
var startDistance = 25




# Intern variables.
var _mouse_position = Vector2(0.0, 0.0)
var _yaw = 0.0
var _pitch = 0.0
var _total_yaw = 0.0
var _total_pitch = 0.0


var rayOrigin = Vector3()
var rayEnd = Vector3()

var _pressed = false

var events = {}
var last_drag_distance = 0


func _ready():
	pivot = get_node("../Camera Rotation Point")	
	set_enabled(enabled)
	distance = startDistance

func _input(event):
	if Global.get_current_tab() != 0: 
		_pressed = false
		return
		
	if event.is_action_pressed("grab"):
		if Camera_Pannable():			
			_pressed = true
	
	if event.is_action_released("grab"):
		_pressed = false

	if event is InputEventMouseButton and !Global.complete:
		if event.is_pressed():
			var change = distance/5
			change = clamp(change, 1, 100)
			if event.button_index == BUTTON_WHEEL_UP:
				distance -= change				

			elif event.button_index == BUTTON_WHEEL_DOWN:
				distance += change

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
	
	if intersection.collider.is_in_group("Drag To Rotate Camera"):
		return true
	
	return false
	

func _process(_delta):
	if events.size() > 1:
		_pressed = false
		
	if events.size() < 2:
			last_drag_distance = 0
			
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
	

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			events[event.index] = event
		else:
			events.erase(event.index)
			
	if event is InputEventScreenDrag:
		events[event.index] = event
			
		if events.size() == 2 and !Global.complete:
			var drag_distance = events[0].position.distance_to(events[1].position)
			
			
			if last_drag_distance == 0:
				last_drag_distance = drag_distance
			elif drag_distance > last_drag_distance:
				distance -= (drag_distance - last_drag_distance)*(0.001 * distance * 3)
			elif drag_distance < last_drag_distance:
				distance -= (drag_distance - last_drag_distance)*(0.001 * distance * 3)
			
			distance = clamp(distance, min_distance, max_distance)	
			last_drag_distance = drag_distance 
				
			
			

func _update_Global_Pointer_Trans():
	
	var space_state = get_world().get_direct_space_state()
	var mouse_position = get_viewport().get_mouse_position()
	rayOrigin = project_ray_origin(mouse_position)
	rayEnd = rayOrigin + project_ray_normal(mouse_position)*2000
	
	var intersection = space_state.intersect_ray(rayOrigin, rayEnd,[],2)
	
	if not intersection.empty():
		Global.pointerTranslation = intersection.position

func _update_mouselook():
	
	_mouse_position *= Saving.camera_sensitivity
	_yaw = _yaw * smoothness + _mouse_position.x * (1.0 - smoothness)
	_pitch = _pitch * smoothness + _mouse_position.y * (1.0 - smoothness)
	_mouse_position = Vector2(0, 0)

	if yaw_limit < 360:
		_yaw = clamp(_yaw, -yaw_limit - _total_yaw, yaw_limit - _total_yaw)
		
	_pitch = clamp(_pitch, (-lower_pitch_limit - _total_pitch) , (upper_pitch_limit - _total_pitch) )

	
	if Global.complete:
		_yaw = 0.2
		_pitch = -lerp(_total_pitch, 0 , .96)
		
	
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
	
	if Global.complete:
		distance = lerp(distance,30, 0.05)
				
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
	
	

	
