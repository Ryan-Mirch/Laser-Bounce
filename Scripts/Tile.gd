extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var open
onready var flag = get_node("StaticBody/OpenFlag")


# Called when the node enters the scene tree for the first time.
func _ready():
	Saving.connect("saveDataUpdated", self, "updateSkin")
	updateSkin()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if Global.debug:
		flag.visible = open
	else:
		flag.visible = false

func setOpen(b):
	open = b	
	
func isOpen():
	return open

func updateSkin():
	var keys = Saving.tilesEquipped.keys()
	if keys.size() > 0:
		
		var equippedItem = keys[0]
		for key in keys:
			if Saving.tilesEquipped[key] == true:
				equippedItem = key
				break
				
		$"AnimationPlayer".play(equippedItem)
