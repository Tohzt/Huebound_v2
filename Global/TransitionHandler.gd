extends Node

var SCREEN: Dictionary = {
	"width" : ProjectSettings.get_setting("display/window/size/viewport_width"),
	"height": ProjectSettings.get_setting("display/window/size/viewport_height"),
	"center": Vector2()
}

static var is_transitioning := false

func _ready():
	SCREEN.center = Vector2(SCREEN.width/2, SCREEN.height/2)

func fade_out(from, to, duration: float, color: Color) -> void:
	var rootControl = CanvasLayer.new()
	var colorRect = ColorRect.new()
	var tween = get_tree().create_tween()
	
	# Keep the root control processing during transitions
	rootControl.set_process_mode(PROCESS_MODE_ALWAYS)
	
	# Setup the color rect with proper anchors and size
	colorRect.color = Color(color.r, color.g, color.b, 0)
	colorRect.anchor_right = 1.0
	colorRect.anchor_bottom = 1.0
	colorRect.offset_right = 0
	colorRect.offset_bottom = 0
	colorRect.grow_horizontal = Control.GROW_DIRECTION_BOTH
	colorRect.grow_vertical = Control.GROW_DIRECTION_BOTH
	
	# Add to scene tree
	get_tree().get_root().add_child(rootControl)
	rootControl.add_child(colorRect)
	
	# Setup tween
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(colorRect, "color", color, duration/2.0)
	
	# Wait for fade out
	await tween.finished
	
	# Instance new scene before freeing old one
	var new_scene = load(to).instantiate()
	get_tree().get_root().add_child(new_scene)
	get_tree().set_current_scene(new_scene)
	
	# Now safe to free the old scene
	if is_instance_valid(from):
		from.queue_free()
	
	# Fade back in
	var tween2 = get_tree().create_tween()
	tween2.set_ease(Tween.EASE_IN)
	tween2.set_trans(Tween.TRANS_LINEAR)
	tween2.tween_property(colorRect, "color", Color(color.r, color.g, color.b, 0), duration/2)
	
	await tween2.finished
	rootControl.queue_free()
	is_transitioning = false
