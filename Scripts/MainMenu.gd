extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currentPage

# Called when the node enters the scene tree for the first time.
func _ready():
	setCurrentPage("Home")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setCurrentPage(pageName):
	for child in get_children():
		child.visible = (child.name == pageName)
		
		if child.name == pageName:
			currentPage = child.name
