extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var mesh = get_node("StaticBody/CollisionShape/Mesh")
onready var ray = get_node("RayCast")
onready var body = get_node("StaticBody")

onready var beam = load("res://Assets/Beam.tscn")

var color
var hasBounced = false
var readyToBounce = false
var scaleY
var collision_point
var distance = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	fix_position()
	set_length(0)
	color = get_parent().color
	call_deferred("set_color")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	

func _physics_process(_delta):	
	if ray.is_colliding():
		var origin = ray.global_transform.origin
		collision_point = ray.get_collision_point()
		distance = origin.distance_to(collision_point) + 0.1
		
	else:
		distance = distance + 0.1
		
	set_length(distance)
		
	if ray.is_colliding():
		if ray.get_collider().is_in_group("Reflect") and !hasBounced and scaleY != 0:
			readyToBounce = true
		if hasBounced and !ray.get_collider().is_in_group("Reflect"):
			unBounce()
			

func fix_position():
	if get_parent().name != "Beam": return
	
	var tile = _get_closest_tile("")
	var tilePos = tile.translation
	
	global_transform.origin.x = tilePos.x
	global_transform.origin.z = tilePos.z
	
	

func set_length(length):
	scaleY = length
	body.scale.y = scaleY + .1
	body.translation.z = scaleY*.5
	
func unBounce():
	var child_beam = get_node_or_null("Beam")
	if child_beam != null:
		child_beam.queue_free()
		
	hasBounced = false
	readyToBounce = true
	
func bounce():
	if !readyToBounce: return
		
	hasBounced = true
	readyToBounce = false
	
	
	var normal = ray.get_collision_normal()
	var d = (ray.global_transform.origin - ray.get_collision_point()).normalized()
	var r = d.bounce(normal).normalized()
	
	var d2 = Vector2(d.x, d.z)
	var r2 = Vector2(r.x, r.z)
	
	var angle = d2.angle_to(r2)
	
	if abs(angle) > 3:		
		return
		
	var beamSpawn = beam.instance()
	
	if angle > 0:
		beamSpawn.rotation_degrees.y = -90
		
	if angle < 0:
		beamSpawn.rotation_degrees.y = 90
	
	
	beamSpawn.translation.z = scaleY
	
	add_child(beamSpawn)
	

func set_color():
	var material = SpatialMaterial.new()
	material.albedo_color = color
	mesh.set_material_override(material)
	
func _get_closest_tile(state): 
	var tiles =  get_tree().get_nodes_in_group("Tile")
	var shortest = -1
	var tile
	
	for t in tiles:
		
		if state == "Open":
			if t.isOpen() == false: #skip if closed
				continue
		if state == "Closed":
			if t.isOpen() == true: #skip if open
				continue
			
		var currentDistance = t.translation.distance_to(global_transform.origin)
		if currentDistance < shortest or shortest == -1:
			shortest = currentDistance
			tile = t
			
	return tile