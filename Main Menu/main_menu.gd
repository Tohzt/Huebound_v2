extends Control
@onready var nine_patch_rect = $NinePatchRect


func _ready():
	nine_patch_rect.modulate = Global.palette_color.pick_random()


func _on_btn_start_pressed():
	get_tree().change_scene_to_file(Global.REFS.Game)


func _on_btn_exit_pressed():
	get_tree().quit()
