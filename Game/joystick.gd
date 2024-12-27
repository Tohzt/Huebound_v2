extends Node2D
signal move_vector

var tap = false
var move = Vector2(0,0)
var swipe = Vector2(0,0)
var origin = Vector2(180,-100)
var touch = origin
var stick = origin
var rad = 60

var pressed = false
var drag = false
var drag_dist_prev = 0
var drag_dist = 0
var drag_cd = 0
var drag_dur = 5
var drag_limit = 50
var drag_origin = Vector2(0,0)
var drag_position = Vector2(0,0)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	# Check platform and handle appropriate input events
	var is_mobile = OS.get_name() in ["Android", "iOS"]
	
	if is_mobile:
		if event is InputEventScreenTouch:
			_handle_touch_press(event)
		elif event is InputEventScreenDrag:
			_handle_drag(event)
	else:
		if event is InputEventMouseButton:
			_handle_touch_press(event)
		elif event is InputEventMouseMotion and pressed:
			_handle_drag(event)

func _handle_touch_press(event):
	if event.pressed:
		pressed = true
		touch = event.position
		stick = touch
		drag_origin = touch
		drag_position = drag_origin
		drag_dist = 0
		swipe = Vector2(0,0)
	
	if !event.pressed:
		if !drag:
			tap = true
		pressed = false
		drag = false
		touch = origin
		stick = origin
		move = Vector2(0,0)
		swipe = Vector2(0,0)
		if drag_dist >= drag_limit:
			swipe = drag_position - drag_origin
		emit_signal("move_vector", move.normalized(), tap, swipe)
		tap = false

func _handle_drag(event):
	if !drag:
		drag = true
		drag_cd = 0
	drag_position = event.position
	stick = touch - (touch - event.position).limit_length(rad)
	move = stick - touch
	emit_signal("move_vector", move.normalized(), tap, swipe)

func _process(_delta):
	if pressed:
		drag_dist_prev = drag_dist
		drag_dist = drag_origin.distance_to(drag_position)
		if drag_dist == drag_dist_prev or drag_cd == 0:
			drag_origin = drag_position
		drag_cd = (drag_cd + 1) % drag_dur
	queue_redraw()

func _draw():
	# TODO: use Huey offset instead of camera to avoid drag 
	var color = Color(1,1,1,0.5)
	var touch_offset = touch
	touch_offset.y -= Global.view_height - $"../Camera2D".offset_pos_y
	var stick_offset = stick
	stick_offset.y -= Global.view_height - $"../Camera2D".offset_pos_y
	
	draw_arc(touch_offset, rad, 0, deg_to_rad(360), 100, Color(1,1,1,0.25), 8, false)
	draw_circle(stick_offset, rad/2, color)
	#printt("touch", touch_offset, "stick", stick_offset)
