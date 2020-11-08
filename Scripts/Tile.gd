extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var open

onready var mesh = get_node("StaticBody/Mesh")


# Called when the node enters the scene tree for the first time.
func _ready():
	var _x = Saving.connect("saveDataUpdated", self, "updateSkin")
	updateSkin()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func setOpen(b):
	open = b	
	
func isOpen():
	return open

func updateSkin():
	if !Saving.tilesEquipped: return
	var keys = Saving.tilesEquipped.keys()
	if keys.size() > 0:
		
		var equippedItem = keys[0]
		for key in keys:
			if Saving.tilesEquipped[key] == true:
				equippedItem = key
				break
		
		mesh.set_surface_material(0,load("res://Materials/Tile/" + equippedItem + " Tile.material"))
		mesh.set_surface_material(1,load("res://Materials/Tile/" + equippedItem + " TileAccent.material"))
		
