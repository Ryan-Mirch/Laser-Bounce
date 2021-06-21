extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var play = get_node("CenterContainer/Play")
onready var pause = get_node("CenterContainer/Pause")
onready var levelCompleteAnimation = get_node("AnimationPlayer")
onready var retryButton = get_node("CenterContainer2/Retry")
onready var transitionEffect = get_node("Transition Effect")
onready var themeName = get_node("Theme Name")
onready var levelName = get_node("Level Name")

var levelComplete = false
var retryDisabled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var _err = Global.connect("tabChanged", self, "tabChanged")
	var fullPath = get_parent().getLevelID()
	var sceneName = fullPath
	sceneName = sceneName.replace(sceneName.get_base_dir(),"") 
	sceneName = sceneName.replace("/","") 
	sceneName = sceneName.replace(".tscn","") 
	levelName.text = sceneName
	
	var sceneTheme = fullPath
	sceneTheme = sceneTheme.replace(sceneTheme.get_base_dir().get_base_dir(), "")
	sceneTheme = sceneTheme.replace(sceneName, "")
	sceneTheme = sceneTheme.replace("tscn", "")
	sceneTheme = sceneTheme.replace("/", "")
	sceneTheme = sceneTheme.replace(".", "")
	themeName.text = sceneTheme


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
		
func tabChanged():
	visible = Global.get_current_tab() == 0
	print(Global.get_current_tab())
	if Global.get_current_tab() != 0 and Global.playing and !Global.complete:
		var Level = get_parent()
		Level.play_pressed()
		pause.visible = false
		play.visible = true

func _on_Play_pressed():
	if Global.get_current_tab() != 0: return
	var Level = get_parent()
	Level.play_pressed()
	pause.visible = true
	play.visible = false
	
func _on_Pause_pressed():
	if Global.get_current_tab() != 0: return
	var Level = get_parent()
	Level.play_pressed()
	pause.visible = false
	play.visible = true

func _Level_Complete():
	pause.visible = false
	play.visible = false
	levelComplete = true
	levelCompleteAnimation.play("Level Complete")
	#transitionEffect.levelCompleted()
	

func _on_Continue_pressed():
	Sounds.play_sound_PickUp()
	
	if Global.get_current_tab() != 0: return
	
	transitionEffect.transition()
	yield(transitionEffect.ap, "animation_finished")
	Global.load_next_level(get_parent().get_filename())


func _on_Retry_pressed():
	if transitionEffect.ap.current_animation != "Fade":
		Global.load_level(get_parent().get_filename())

