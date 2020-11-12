extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var levelSelect = get_node("../..")
onready var label = get_node("Label")

export(String) var itemName = ""
export(String) var ID = ""
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
func _process(_delta):
	pass
	
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
	
	if dic.has(ID):
		selected = getSaveDictionary()[ID]
	else:
		selected = defaultOn
		updateSaveData()
		Saving.updateSaveData()
		
	get_node("AnimationPlayer").play_backwards("Selected")	
	
	setSelected(selected)

func updateSaveData():
	getSaveDictionary()[ID] = selected	
	
func setSelected(b):
	
	if selected and !b:
		get_node("AnimationPlayer").play_backwards("Selected")
	
	if b:
		get_node("AnimationPlayer").play("Selected")
		
	selected = b
	
	
	

func setLabelText():
	label.text = itemName

func pressed():
	if selected: return
	
	for b in get_tree().get_nodes_in_group(buttonGroup):
		b.setSelected(false)
		b.updateSaveData()
	
	setSelected(true)
	Sounds.play_sound_PickUp()
	updateSaveData()
	Saving.updateSaveData()

func _on_Panel_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
	   pressed()
