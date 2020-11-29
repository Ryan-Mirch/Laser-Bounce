extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String) var itemName
export(String) var itemSKU


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = itemName


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func pressed():
	
	Global.iap.purchaseConsumable(itemSKU)

func _on_Panel_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
	   pressed()
