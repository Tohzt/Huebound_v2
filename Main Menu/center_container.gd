extends CanvasLayer

#@onready var menu_options = $"Menu Options"
@onready var settings_options = $"Settings Options"
#@onready var btn_start = $"Menu Options/BTN_Start"
#@onready var btn_settings = $"Menu Options/BTN_Settings"
#@onready var btn_leaderboard = $"Menu Options/BTN_Leaderboard"
#@onready var btn_exit = $"Menu Options/BTN_EXIT"


func _ready():
	#menu_options.show()
	settings_options.hide()
	#btn_start.modulate = Global.palette_color.pick_random()
	#btn_settings.modulate = Global.palette_color.pick_random()
	#btn_leaderboard.modulate = Global.palette_color.pick_random()
	#btn_exit.modulate = Global.palette_color.pick_random()

func _on_btn_settings_pressed():
	pass
	#menu_options.hide()
	#settings_options.show()

func _on_btn_back_pressed():
	pass
	#menu_options.show()
	#settings_options.hide()

func _on_btn_leaderboard_pressed():
	pass
	#var leaderboard_scene = preload(Global.REFS.Leaderboard)
	#var leaderboard_instance = leaderboard_scene.instantiate()
	#add_child(leaderboard_instance)
	#leaderboard_instance.nine_patch_rect.modulate = btn_leaderboard.modulate
