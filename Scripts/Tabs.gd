extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var settingsTab = get_node("Settings")
onready var levelSelectTab = get_node("Level Select")
onready var storeTab = get_node("Store")

signal tabChanged

var currentTab = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_current_tab(tab):
	if tab == 0: _on_Game_pressed()
	if tab == 1: _on_Level_Select_pressed()
	if tab == 2: _on_Store_pressed()
	if tab == 3: _on_Settings_pressed()	
		

func _on_Game_pressed():
	close_all_tabs()
	currentTab = 0
	Global.emit_signal("tabChanged")

func _on_Level_Select_pressed():
	close_all_tabs()
	levelSelectTab.visible = true
	currentTab = 1
	Global.emit_signal("tabChanged")
	
func _on_Store_pressed():
	close_all_tabs()
	storeTab.visible = true
	currentTab = 2
	Global.emit_signal("tabChanged")

func _on_Settings_pressed():
	close_all_tabs()
	settingsTab.visible = true
	currentTab = 3
	Global.emit_signal("tabChanged")

	
func close_all_tabs():
	settingsTab.visible = false
	levelSelectTab.visible = false
	storeTab.visible = false
