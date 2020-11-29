extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var currencyAmountLabel = $"Panel/HBoxContainer/Currency Amount"
var startingY = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	startingY = $Panel.rect_position.y
	Global.currencyDisplay = self
	Saving.connect("saveDataUpdated",self,"updateCurrency")
	Global.admob.connect("banner_loaded", self, "make_room_for_Banner")
	updateCurrency()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func updateCurrency():
	currencyAmountLabel.text = str(Saving.currency)


func _on_Panel_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		Global.tabs.set_current_tab(3)
		Saving.updateCurrency(100)
		
func make_room_for_Banner():
	$Panel.rect_position.y = startingY + Global.admob.get_banner_dimension().y
	
	
