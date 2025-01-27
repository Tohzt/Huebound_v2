extends Control
@onready var current_item = $Control/Current_Item
@onready var current_power = $"Control/Current Power"

var Hue: HueClass

func _ready():
	Hue = get_tree().get_first_node_in_group("Hue")

func _process(_delta):
	current_power.text = Hue.power
	match Hue.power:
		"triple_jump":
			current_item.show()
			current_item.frame = 0
		"wall_cling":
			current_item.show()
			current_item.frame = 1
		"shuffle":
			current_item.show()
			current_item.frame = 2
		"random_swap":
			current_item.show()
			current_item.frame = 3
		"": current_item.hide()

func _on_btn_exit_pressed():
	Global.active_color.clear()
	get_tree().change_scene_to_file(Global.REFS.Start)
