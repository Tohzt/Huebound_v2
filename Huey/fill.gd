extends Sprite2D

@onready var master = get_parent()
var animating = false
var frame_sequence = 0  # 0: forward, 1: color change, 2: backward
var animation_speed = 40  # Frames per second
var animation_timer = 0
var target_color: Color  # Store the color we'll change to

func _ready():
	$"../border".global_position.x = master.position.x
	global_position.x = master.position.x
	$"../border".global_position.y = master.position.y-40
	global_position.y = master.position.y-40
	frame = 0  # Ensure we start at frame 0

func _process(delta):
	var target_position = master.position
	target_position.y = master.position.y-40
	var spd = 20
	global_position = lerp(global_position, target_position, delta*spd)
	if master.alive:
		$"../border".global_position.x = master.position.x
		$"../border".global_position.y = master.position.y-40
	else:
		global_position.y = master.global_position.y-40
	$"../backfill".global_position = global_position
	if animating:
		animate(delta)

func start_animation(new_color: Color):
	animating = true
	frame_sequence = 0
	frame = 0
	animation_timer = 0
	target_color = new_color

func animate(delta):
	animation_timer += delta * animation_speed
	
	match frame_sequence:
		0:  # Forward animation (0 to 8)
			if animation_timer >= 1:
				animation_timer = 0
				frame += 1
				if frame >= 5:
					frame_sequence = 1
		
		1:  # Color change pause
			animation_timer = 0
			modulate = target_color  # Apply the color change here
			frame_sequence = 2
		
		2:  # Backward animation (8 to 0)
			if animation_timer >= 1:
				animation_timer = 0
				frame -= 1
				if frame <= 0:
					animating = false
					frame_sequence = 0
