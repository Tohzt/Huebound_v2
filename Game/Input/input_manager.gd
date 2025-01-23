# input_manager.gd
extends Node

signal interaction_ended(position: Vector2, was_tap: bool)
signal interaction_moved(movement: Vector2)
signal interaction_swiped(direction: Vector2)
@onready var touch_origin = $"../Touch_Origin"
@onready var touch_pos = $"../Touch_Pos"

const MAX_TOUCH_DISTANCE = 100.0
const TAP_THRESHOLD = 10.0
const MOVEMENT_THRESHOLD = 50.0
const MIN_UPWARD_ANGLE = -135  # Reduced from -165 (now 45 degrees from vertical instead of 75)
const MAX_UPWARD_ANGLE = -45   # Increased from -15 (now 45 degrees from vertical instead of 75)

var is_touching = false
var initial_touch_position = Vector2.ZERO
var total_movement = Vector2.ZERO

func _ready():
	touch_origin.hide()
	touch_pos.hide()

func _process(_delta):
	if is_touching:
		var viewport = get_viewport()
		var position = viewport.get_camera_2d().get_screen_center_position()
		position += initial_touch_position - viewport.get_visible_rect().size / 2
		touch_origin.global_position = position
		
		# Calculate current touch position relative to origin
		var current_touch = get_viewport().get_mouse_position()
		var touch_offset = current_touch - initial_touch_position
		
		# Clamp the touch_pos distance from origin
		if touch_offset.length() > MAX_TOUCH_DISTANCE:
			touch_offset = touch_offset.normalized() * MAX_TOUCH_DISTANCE
		
		# Update touch_pos position
		var current_pos = touch_origin.global_position + touch_offset
		touch_pos.global_position = current_pos
		
		# Calculate horizontal movement relative to initial touch position
		var movement_delta = Vector2(touch_offset.x, 0)
		total_movement = movement_delta
		var normalized_movement = movement_delta / MOVEMENT_THRESHOLD
		normalized_movement.x = clamp(normalized_movement.x, -1.0, 1.0)
		
		interaction_moved.emit(Vector2(normalized_movement.x, 0))

func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		var is_pressed = event.pressed
		var viewport = get_viewport()
		var position = viewport.get_camera_2d().get_screen_center_position()
		position += event.position - viewport.get_visible_rect().size / 2
		
		if event is InputEventMouseButton and event.button_index != MOUSE_BUTTON_LEFT:
			return
			
		if is_pressed:
			is_touching = true
			initial_touch_position = event.position
			total_movement = Vector2.ZERO
			touch_origin.show()
			touch_pos.show()
			touch_origin.global_position = position
			touch_pos.global_position = position
		else:
			is_touching = false
			touch_origin.hide()
			touch_pos.hide()
			
			# Get final joystick position
			var final_offset = event.position - initial_touch_position
			
			# Check if joystick was at max distance
			if final_offset.length() >= MAX_TOUCH_DISTANCE * 0.9:  # 90% of max distance
				var angle = rad_to_deg(final_offset.angle())
				if angle >= MIN_UPWARD_ANGLE and angle <= MAX_UPWARD_ANGLE:
					var jump_dir = final_offset.normalized()
					interaction_swiped.emit(jump_dir)
			
			# Check for tap
			var total_distance = final_offset.length()
			var was_tap = total_distance < TAP_THRESHOLD
			interaction_ended.emit(Vector2.ZERO, was_tap)
