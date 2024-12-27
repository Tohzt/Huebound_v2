extends Node2D
@onready var start_marker = $"Start Marker"
@onready var tap_marker = $"Tap Marker"

var touch_position = Vector2.ZERO
var is_touching = false
var touch_start_time = 0.0  # Track when touch started
var touch_start_position = Vector2.ZERO  # Track where touch started
@onready var huey: HueClass = get_parent().Hue

# Constants for gesture detection
const TAP_THRESHOLD_TIME = 0.2  # Maximum time for a tap in seconds
const TAP_MOVEMENT_THRESHOLD = 10  # Maximum movement allowed for a tap
const FLICK_VELOCITY_THRESHOLD = 1000  # Minimum velocity for a flick

func _ready():
	if !huey: huey = get_tree().get_first_node_in_group("Hue")
	start_marker.hide()
	tap_marker.hide()

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			_start_touch(event.position)
		else:
			_end_touch(event.position)
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_start_touch(event.position)
			else:
				_end_touch(event.position)
	elif event is InputEventMouseMotion and is_touching:
		touch_position = event.position
		touch_position.y -= Global.screen_height

# Helper function to handle touch/click start
func _start_touch(pos: Vector2):
	is_touching = true
	touch_start_time = Time.get_ticks_msec() / 1000.0
	touch_start_position = pos
	touch_position = pos
	
	# Invert Y coordinate to match game's coordinate system
	touch_position.y -= Global.screen_height
	touch_start_position.y -= Global.screen_height
	
	start_marker.position = touch_position
	start_marker.show()  # Explicitly show the marker
	

# Helper function to handle touch/click end
func _end_touch(pos: Vector2):
	var end_position = pos
	# Invert Y coordinate for end position too
	end_position.y = -pos.y
	
	var touch_duration = (Time.get_ticks_msec() / 1000.0) - touch_start_time
	var movement = end_position - touch_start_position
	var velocity = movement.length() / touch_duration
	
	# Check for tap
	if touch_duration < TAP_THRESHOLD_TIME and movement.length() < TAP_MOVEMENT_THRESHOLD:
		huey.mv_jump = true
	# Check for flick
	elif velocity > FLICK_VELOCITY_THRESHOLD:
		huey.mv_jump = true
	
	is_touching = false
	touch_position = Vector2.ZERO

func _process(_delta):
	if !huey: huey = get_tree().get_first_node_in_group("Hue")
	start_marker.visible = is_touching
	tap_marker.visible = is_touching
	
	huey.mv_left = false
	huey.mv_right = false
	
	if is_touching:
		tap_marker.position = touch_position 
		
		if tap_marker.position.x > start_marker.position.x:
			huey.mv_right = true
		elif tap_marker.position.x < start_marker.position.x:
			huey.mv_left = true

	
