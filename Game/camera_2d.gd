extends Camera2D

@onready var Target = get_parent().get_node("Hue")
@onready var start_pos = position

@export var base_scroll_speed: float = 5.0  # Base speed per height tier
@export var max_scroll_speed: float = 60.0  # Maximum scroll speed
var current_scroll_speed = 0.0  # Current scroll speed

func _ready():
	self.limit_right = Global.view_width

func _process(delta):
	# Don't scroll until height exceeds 10
	if Global.height <= 10:
		current_scroll_speed = 0.0
	else:
		# Calculate how many tiers of 10 height we've achieved past the initial 10
		var height_tiers = floor((Global.height - 10.0) / 10.0)
		# Increase speed by base_scroll_speed for each tier
		current_scroll_speed = min(base_scroll_speed * (height_tiers + 1), max_scroll_speed)
	
	# Apply the scroll
	position.y -= current_scroll_speed * delta
	
	# Still follow the player if they're above the camera
	if Target.global_position.y < position.y:
		position.y = lerp(position.y, Target.position.y, delta)
