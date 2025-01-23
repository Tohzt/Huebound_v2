extends Control
@onready var current_item = $Current_Item

var Hue: HueClass

func _ready():
	Hue = get_tree().get_first_node_in_group("Hue")

func _process(_delta):
	match Hue.power:
		"triple_jump":
			current_item.show()
			current_item.frame = 0
		"wall_cling":
			current_item.show()
			current_item.frame = 1
		"": current_item.hide()

func _on_btn_exit_pressed():
	Global.active_color.clear()
	get_tree().change_scene_to_file(Global.REFS.Start)
