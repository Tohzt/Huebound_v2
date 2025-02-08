extends HBoxContainer
@onready var label_height = $VBoxContainer/Label_Height
@onready var label_height_max = $Label_Height_Max
@onready var label_best = $VBoxContainer/Label_Best


func _process(_delta):
	# TODO: Don't run every frame
	if Global.height > Global.top_10:
		label_height.modulate = Color.GOLD
	label_height.text = "Current: " + str(Global.height)
	label_height_max.text = "All Time: " + str(Global.height_max)
	label_best.text = "Best: " + str(Global.personal_best)
