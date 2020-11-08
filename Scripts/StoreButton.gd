extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var levelSelect = get_node("../..")
onready var label = get_node("Label")
onready var selectedIcon = get_node("Selected")

export(String) var itemName = ""
export(String, "Lasers", "Laser Sounds", "Backgrounds", "Tiles") var buttonGroup = ""
export var defaultOn = false

var selected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Saving.connect("saveDataReset",self,"loadFromSaveData")
	add_to_group(buttonGroup)
	setLabelText()
	loadFromSaveData()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	selectedIcon.pressed = selected
	
func getSaveDictionary():
	if buttonGroup == "Lasers":
		return Saving.lasersEquipped
	elif buttonGroup == "Laser Sounds":
		return Saving.laserSoundsEquipped
	elif buttonGroup == "Backgrounds":
		return Saving.backgroundsEquipped
	elif buttonGroup == "Tiles":
		return Saving.tilesEquipped
	
func loadFromSaveData():
	var dic = getSaveDictionary()
	
	if dic.has(itemName):
		selected = getSaveDictionary()[itemName]
	else:
		selected = defaultOn

func updateSaveData():
	getSaveDictionary()[itemName] = selected	
	

func setLabelText():
	label.text = itemName

func _on_Node2D_pressed():
	if selected: return
	
	for b in get_tree().get_nodes_in_group(buttonGroup):
		b.selected = false
		b.updateSaveData()
	
	selected = true
	Global.soundManager.play_sound_PickUp()
	updateSaveData()
	Saving.updateSaveData()
	
