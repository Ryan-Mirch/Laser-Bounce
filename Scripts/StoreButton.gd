extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var levelSelect = get_node("../..")
onready var labelItemName = get_node("Item Name")
onready var labelPurchasePrice = get_node("Stars Required/Purchase Price")
onready var starsRequired = get_node("Stars Required")

onready var unlockAnimation = get_node("Unlock Animation")
onready var selectAnimation = get_node("Select Animation")

export(String) var itemName = ""
export(int) var purchasePrice = ""
export(String) var ID = ""
export(String, "Lasers", "Laser Sounds", "Backgrounds", "Tiles") var buttonGroup = ""
export var defaultOn = false

var selected = false
var unlocked = false

signal cantAfford

# Called when the node enters the scene tree for the first time.
func _ready():
	var _x = Saving.connect("saveDataReset",self,"loadFromSaveData")
	var _y = Saving.connect("saveDataUpdated",self,"unlock")
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
		
	selectAnimation.play_backwards("Selected")	
	
	setSelected(selected)
	Saving.updateSaveData()
	
func updateSaveData():
	getSaveDictionary()[ID] = selected	
	
func unlock():
	if Saving.getLevelsCompleted() >= purchasePrice and !unlocked:
		unlocked = true
		unlockAnimation.play("Unlocked")
	
func setSelected(b):
	
	if selected and !b:
		selectAnimation.play_backwards("Selected")
	
	if b:
		selectAnimation.play("Selected")
		
	selected = b


func setLabelText():
	labelItemName.text = itemName
	labelPurchasePrice.text = str(purchasePrice)
	if purchasePrice == 0:
		starsRequired.visible = false

func pressed():
	if selected: return
	
	if !unlocked:
		emit_signal("cantAfford")
		return false
	
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
