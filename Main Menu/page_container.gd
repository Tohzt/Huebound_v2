extends Node2D

var page = 1
var next_page = 1
var offset_position = 0.0
var can_change = true

func _ready():
	pass # Replace with function body.


func _process(delta):
	if page != next_page:
		page = next_page
		_set_page(next_page)
	
	if position.x != offset_position:
		position.x = lerp(position.x, offset_position, delta*3)

func _set_page(_next_page: int) -> void:
	match _next_page:
		1:
			offset_position = 0.0
		2:
			offset_position = -600.0
		3:
			offset_position = 720.0
