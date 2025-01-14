extends NinePatchRect
@onready var input_name: LineEdit = $CenterContainer/VBoxContainer/InputName
@onready var submit_score = $"CenterContainer/VBoxContainer/Submit Score"

func _ready():
	submit_score.disabled = true
	hide()

func _process(_delta):
	if input_name.text.length():
		submit_score.disabled = false

func _on_submit_score_pressed():
	Global.player_name = input_name.text
	Global.record_set = false
	SilentWolf.Scores.save_score(Global.player_name, Global.height_max)
	var huey = get_tree().get_first_node_in_group("Hue")
	if huey:
		huey.active = true
	else:
		Global.chunks = 0
		Global.active_color.clear()
		get_tree().change_scene_to_file(Global.REFS.Start)
	hide()
