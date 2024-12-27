extends Button

var selected = false
@export var index: int
@export var color: Color
@onready var color_rect: ColorRect = $ColorRect

func _ready():
	color_rect.color = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	selected = Global.palette_color.has(index)
	
	if selected:
		color_rect.color.a = 1.0
	else:
		color_rect.color.a = 0.25


func _on_pressed():
	if selected:
		Global.palette_color.erase(index)
	else:
		Global.palette_color.append(index)
