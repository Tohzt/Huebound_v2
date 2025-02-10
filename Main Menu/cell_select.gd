extends Button
@onready var texture_rect = $HBoxContainer/TextureRect
@onready var texture_rect_2 = $HBoxContainer/TextureRect2
@onready var texture_rect_3 = $HBoxContainer/TextureRect3
@onready var texture_rect_4 = $HBoxContainer/TextureRect4

@export var col_1: Color = Color.WHITE
@export var col_2: Color
@export var col_3: Color
@export var col_4: Color

var selected = false

func _ready():
	texture_rect.modulate = col_1
	texture_rect_2.modulate = col_2
	texture_rect_3.modulate = col_3
	texture_rect_4.modulate = col_4

func _on_pressed():
	Global.color_palette = [col_1, col_2, col_3, col_4]
