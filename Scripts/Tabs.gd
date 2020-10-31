extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var settingsWindow= get_node("Settings")
onready var levelSelectWindow = get_node("Level Select")
onready var storeWindow = get_node("Store")
onready var blockGameScreen = get_node("BlockGameScreen")

onready var gameTab = get_node("Panel/HBoxContainer/Game")
onready var levelSelectTab = get_node("Panel/HBoxContainer/Level Select")
onready var storeTab = get_node("Panel/HBoxContainer/Store")
onready var settingsTab = get_node("Panel/HBoxContainer/Settings")


var currentTab = 0

# Called when the node enters the scene tree for the first time.
func _ready():	
	Global.admob.connect("banner_loaded", self, "make_room_for_Banner")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
func make_room_for_Banner():	
	var ratio = get_viewport().get_visible_rect().size.y / get_viewport().get_visible_rect().size.x
	ratio = clamp(ratio, 1, 100)
	var h = pow(Global.admob.get_banner_dimension().y * ratio, 1.05)
	settingsWindow.margin_top = h
	levelSelectWindow.margin_top = h
	storeWindow.margin_top = h
		
		
func remove_room_for_Banner():
	settingsWindow.margin_top = 0
	levelSelectWindow.margin_top = 0
	storeWindow.margin_top = 0
		
func set_current_tab(tab):
	if tab == 0: _on_Game_pressed()
	if tab == 1: _on_Level_Select_pressed()
	if tab == 2: _on_Store_pressed()
	if tab == 3: _on_Settings_pressed()	
	
		

func _on_Game_pressed():
	close_all_tabs()
	gameTab.pressed = true
	currentTab = 0
	Global.emit_signal("tabChanged")
	blockGameScreen.visible = false

func _on_Level_Select_pressed():
	close_all_tabs()
	levelSelectWindow.visible = true
	levelSelectTab.pressed = true
	currentTab = 1
	Global.emit_signal("tabChanged")
	
	
func _on_Store_pressed():
	close_all_tabs()
	storeWindow.visible = true
	storeTab.pressed = true
	currentTab = 2
	Global.emit_signal("tabChanged")

func _on_Settings_pressed():
	close_all_tabs()
	settingsWindow.visible = true
	settingsTab.pressed = true
	currentTab = 3
	Global.emit_signal("tabChanged")

	
func close_all_tabs():
	Global.soundManager.play_sound_Rotate()
	
	settingsWindow.visible = false
	levelSelectWindow.visible = false
	storeWindow.visible = false
	
	gameTab.pressed = false
	levelSelectTab.pressed = false
	storeTab.pressed = false
	settingsTab.pressed = false
	
	blockGameScreen.visible = true
