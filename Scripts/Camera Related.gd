extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var CameraRotationPoint = $"Camera Rotation Point"
onready var DirectionalLight = $"DirectionalLight"

# Called when the node enters the scene tree for the first time.
func _ready():
	var _x = Saving.connect("saveDataUpdated", self, "update")
	update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	
func update():
	updateSkin()
	updateShadows()
	updateCameraRotationPoint()

func updateCameraRotationPoint():
	if Global.admob.get_banner_offset() > 0:
		CameraRotationPoint.translation.y = 3
	else:
		CameraRotationPoint.translation.y = 0

func updateSkin():
	if !Saving.backgroundsEquipped: return
	var keys = Saving.backgroundsEquipped.keys()
	if keys.size() > 0:
		
		var equippedItem = keys[0]
		for key in keys:
			if Saving.backgroundsEquipped[key] == true:
				equippedItem = key
				break
		$"Camera".environment = load("res://Environments/" + equippedItem + ".tres")
		

func updateShadows():
	DirectionalLight.shadow_enabled = Saving.enableShadows
