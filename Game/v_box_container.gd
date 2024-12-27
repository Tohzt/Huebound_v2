extends VBoxContainer
@onready var label_height = $Label_Height
@onready var label_height_max = $Label_Height_Max


func _process(delta):
	# TODO: Don't run every frame
	label_height.text = "Current: " + str(Global.height)
	label_height_max.text = "All Time: " + str(Global.height_max)
