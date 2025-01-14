extends Sprite2D

func _process(delta):
	global_position = lerp(global_position, get_parent().position, delta*10)
