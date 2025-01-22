extends Control

func _on_btn_exit_pressed():
	Global.active_color.clear()
	get_tree().change_scene_to_file(Global.REFS.Start)
