extends VBoxContainer
@onready var on_screen_input: CheckBox = $"on-screen input"

func _ready():
	on_screen_input.button_pressed = Settings.on_screen_input

func _on_onscreen_input_pressed():
	Settings.on_screen_input = on_screen_input.button_pressed
