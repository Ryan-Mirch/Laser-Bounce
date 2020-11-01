extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Laser = get_node("Laser")
onready var DoorOpen = get_node("Door Open")
onready var DoorClose = get_node("Door Close")
onready var PlayLevel = get_node("Play Level")
onready var StopLevel = get_node("Stop Level")
onready var PickUp = get_node("Pick Up")
onready var PutDown = get_node("Put Down")
onready var Rotate = get_node("Rotate")
onready var Win = get_node("Win")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func play_sound_Laser():
	if !Saving.enableSound: return
	if Laser:
		Laser.playSound()
	
func play_sound_DoorOpen():
	if !Saving.enableSound: return
	if DoorOpen:
		DoorOpen.playSound()
	
func play_sound_DoorClose():
	if !Saving.enableSound: return
	if DoorClose:
		DoorClose.playSound()
	
func play_sound_PlayLevel():
	if !Saving.enableSound: return
	if PlayLevel:
		PlayLevel.playSound()
	
func play_sound_StopLevel():
	if !Saving.enableSound: return
	if StopLevel:
		StopLevel.playSound()
	
func play_sound_PickUp():
	if !Saving.enableSound: return
	if PickUp:
		PickUp.playSound()
	
func play_sound_PutDown():
	if !Saving.enableSound: return
	if PutDown:
		PutDown.playSound()
	
func play_sound_Rotate():
	if !Saving.enableSound: return
	if Rotate:
		Rotate.playSound()
	
func play_sound_Win():
	if !Saving.enableSound: return
	if Win:
		Win.playSound()

