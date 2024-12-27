extends HBoxContainer

var Hue: HueClass

func _ready():
	Hue = get_tree().get_first_node_in_group("Hue")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_btn_jump():
	Hue.mv_jump = true


func _on_btn_left_button_down():
	Hue.mv_left = true

func _on_btn_left_button_up():
	Hue.mv_left = false


func _on_btn_right_button_down():
	Hue.mv_right = true

func _on_btn_right_button_up():
	Hue.mv_right = false


func _on_btn_exit_pressed():
	get_tree().change_scene_to_file(Global.REFS.Start)
