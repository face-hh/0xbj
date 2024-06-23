extends Label

@onready var timer: Timer = $"../Timer"

var pc: float

func subtitle(new_text: String):
	text = new_text
	visible_ratio = 0.0
	$"../Timer".start()
	pc = 1.0 / text.length()

func _on_timer_timeout():
	if visible_ratio == 0:
		add_theme_font_size_override("font_size", int(71 - (10 +  (text.length() / 12))))
		add_theme_constant_override("outline_size", int(35 - (3 +  (text.length() / 12))))
	
	visible_ratio += pc
	if visible_ratio >= 1.0:
		$"../Timer".stop()
