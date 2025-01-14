extends Camera2D

@onready var Target = get_parent().get_node("Hue")
@onready var start_pos = position
var offset_pos_y = 0 

func _ready():
	self.limit_right = Global.view_width

func _process(delta):
	#offset_pos_y = min(0, position.y - start_pos.y)
	#position.y = lerp(position.y, Target.position.y,delta*10)
	# BUG: Print these and see whats going on
	if Target.global_position.y < start_pos.y:
		position.y = lerp(position.y, Target.position.y, delta * 5)
	else: 
		position.y = lerp(position.y, start_pos.y, delta * 5)
