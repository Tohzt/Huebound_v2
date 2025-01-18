extends Camera2D

@onready var Target = get_parent().get_node("Hue")
@onready var start_pos = position

var max_scroll_speed = 50.0  # Maximum scroll speed in pixels per second
var current_scroll_speed = 0  # Current scroll speed
var acceleration_time = 3.0  # Time in seconds to reach max speed
var time_elapsed = 0.0  # Track elapsed time since start

func _ready():
	self.limit_right = Global.view_width

func _process(delta):
	# Gradually increase scroll speed
	if time_elapsed < acceleration_time:
		time_elapsed += delta
		current_scroll_speed = lerp(0.0, max_scroll_speed, time_elapsed / acceleration_time)
	
	# Constant upward scroll
	position.y -= current_scroll_speed * delta
	
	# Still follow the player if they're above the camera
	if Target.global_position.y < position.y:
		position.y = lerp(position.y, Target.position.y, delta)
