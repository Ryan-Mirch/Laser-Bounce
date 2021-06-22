extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var levelSelect = get_node("../..")
onready var labelItemName = get_node("Item Name")
onready var labelPurchasePrice = get_node("Stars Required/Purchase Price")
onready var starsRequired = get_node("Stars Required")
onready var iconTextureRect = get_node("TextureRect")

onready var selectAnimation = get_node("Select Animation")

export(Texture) var iconTexture
export(String) var itemName = ""
export(int) var purchasePrice = ""
export(String) var ID = ""
export(String, "Lasers", "Laser Sounds", "Backgrounds", "Tiles") var buttonGroup = ""
export var defaultOn = false

var selected = false
var unlocked = false

var posOfClickStart
var isPressed = false
var deadZone = 20

signal cantAfford

# Called when the node enters the scene tree for the first time.
func _ready():
	var _x = Saving.connect("saveDataReset",self,"loadFromSaveData")
	var _y = Saving.connect("saveDataUpdated",self,"unlock")
	add_to_group(buttonGroup)
	setLabelText()
	loadFromSaveData()
	setIconTexture()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
	
func setIconTexture():
	iconTextureRect.texture = iconTexture

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
		starsRequired.visible = false
	
func setSelected(b):
	
	if selected and !b:
		selectAnimation.play_backwards("Selected")
	
	if b:
		selectAnimation.play("Selected")
		
	selected = b


func setLabelText():
	labelItemName.text = itemName
	labelPurchasePrice.text = str(purchasePrice)
	if purchasePrice > 0:
		starsRequired.visible = true

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
	if event.is_action_released("grab") and isPressed:
		isPressed = false
		
		if posOfClickStart.distance_to(get_viewport().get_mouse_position()) <= deadZone:
			pressed()
			
	if event.is_action_pressed("grab") and !isPressed:
		posOfClickStart = get_viewport().get_mouse_position()
		isPressed = true	
