extends Sprite2D

func _ready():
	$"../border".global_position.x = get_parent().position.x
	global_position.x = get_parent().position.x
	$"../border".global_position.y = get_parent().position.y-40
	global_position.y = get_parent().position.y-40

func _process(delta):
	var target_position = get_parent().position
	target_position.y = get_parent().position.y-40
	global_position = lerp(global_position, target_position, delta*10)
	$"../border".global_position.x = get_parent().position.x
	$"../border".global_position.y = get_parent().position.y-40
