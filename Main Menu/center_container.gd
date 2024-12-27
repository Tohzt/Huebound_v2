extends CenterContainer

@onready var menu_options = $"Menu Options"
@onready var settings_options = $"Settings Options"


func _ready():
	menu_options.show()
	settings_options.hide()


func _on_btn_settings_pressed():
	menu_options.hide()
	settings_options.show()


func _on_btn_back_pressed():
	menu_options.show()
	settings_options.hide()
