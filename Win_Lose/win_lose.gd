extends Control
@onready var nine_patch_rect = $NinePatchRect
@onready var label = $CenterContainer/VBoxContainer/Label
@onready var input_name = $CenterContainer/VBoxContainer/InputName
@onready var submit_score = $"CenterContainer/VBoxContainer/Submit Score"


func _ready():
	input_name.visible = Global.new_record
	submit_score.visible = Global.new_record
	nine_patch_rect.modulate = Global.active_color[0]
	submit_score.disabled = true


func _process(_delta):
	if input_name.text.length():
		submit_score.disabled = false


func _on_btn_play_again_pressed():
	get_tree().change_scene_to_file(Global.REFS.Game)

func _on_btn_exit_pressed():
	get_tree().change_scene_to_file(Global.REFS.Start)

func _on_submit_score_pressed():
	Global.player_name = input_name.text
	Global.new_record = false
	SilentWolf.Scores.save_score(Global.player_name, Global.height_max)
	get_tree().change_scene_to_file(Global.REFS.Start)
