extends UI_CELL_CLASS

var time_offset: float
var is_rumbling := false
var rumble_amplitude := 5.0
var rumble_frequency := 4.0
var is_in_position := false
var color_change_timer := 0.0
const COLOR_CHANGE_INTERVAL := 0.75

func _ready():
	super._ready()
	
	time_offset = randf() * PI * 2
	
	color = Global.palette_grey.pick_random()
	color_shaded = color
	modulate = color_shaded.darkened(0.5)
	
	# Connect to the START button's signal
	var start_button = get_tree().get_first_node_in_group("start_button")
	if start_button:
		start_button.start_pressed.connect(_on_start_pressed)

func _on_start_pressed():
	is_rumbling = true
	is_in_position = false
	color_change_timer = 0.0

func _process(delta):
	if is_rumbling:
		if !is_in_position:
			pos = lerp(pos, pos_in, delta * slide_speed)
			# Check if we're close enough to start rumbling
			if abs(pos - pos_in) < 1.0:
				is_in_position = true
		else:
			# Start the rumble effect once in position
			var t = Time.get_ticks_msec() / 1000.0
			pos = pos_in + rumble_amplitude * abs(sin(t * rumble_frequency + time_offset))
			
			# Handle color changes
			color_change_timer += delta
			if color_change_timer >= COLOR_CHANGE_INTERVAL:
				color = Global.color_palette.pick_random()
				color_shaded = color
				modulate = color_shaded.darkened(0.5)
				color_change_timer = 0.0
	else:
		pos = pos_out
	
	position.y = lerp(position.y, pos, delta * slide_speed * 2)
