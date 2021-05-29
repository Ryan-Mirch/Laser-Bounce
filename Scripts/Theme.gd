extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (String) var themeName
export(String, DIR) var themePath

onready var themeLabel = get_node("ThemeName/Label")

# Called when the node enters the scene tree for the first time.
func _ready():
	themeLabel.text = themeName

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func getThemePath():
	return themePath
