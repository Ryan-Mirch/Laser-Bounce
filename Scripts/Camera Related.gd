extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var _x = Saving.connect("saveDataUpdated", self, "updateSkin")
	updateSkin()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func updateSkin():
	if !Saving.backgroundsEquipped: return
	var keys = Saving.backgroundsEquipped.keys()
	if keys.size() > 0:
		
		var equippedItem = keys[0]
		for key in keys:
			if Saving.backgroundsEquipped[key] == true:
				equippedItem = key
				break
		print(equippedItem)
		$"Camera".environment = load("res://Environments/" + equippedItem + ".tres")
		
