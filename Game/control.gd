extends Control
@onready var bot_right = $Bot_Right
@onready var bot_bot = $Bot_Bot
@onready var bot_left = $Bot_Left

var Hue: HueClass


func _ready():
	Hue = get_tree().get_first_node_in_group("Hue")
	_show_hide(false)
	if Settings.on_screen_input:
		_show_hide(true)

func _show_hide(TorF):
	bot_left.visible  = TorF
	bot_bot.visible   = TorF
	bot_right.visible = TorF
	
	

func _on_tsb_jump_pressed():
	Hue.mv_jump = true

func _on_tsb_down_pressed():
	Hue.mv_down = true

func _on_tsb_left_pressed():
	Hue.mv_left = true

func _on_tsb_left_released():
	Hue.mv_left = false

func _on_tsb_right_pressed():
	Hue.mv_right = true

func _on_tsb_right_released():
	Hue.mv_right = false
