extends Node

@onready var color_rect: ColorRect = $ColorRect

func face_talking():
	var tween = create_tween()
	
	tween.parallel().tween_property($Face, "position", Vector2(-725, 282), 0.5)
	tween.parallel().tween_property($Face, "modulate:a", 1, 0.5)
	
	tween.parallel().tween_property($Blackjack, "position", Vector2(1608, 243), 0.5)
	tween.parallel().tween_property($Blackjack, "modulate:a", 0, 0.5)
	
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	
	tween.play()

func gameplay():
	var tween = create_tween()
	
	tween.parallel().tween_property($Face, "position", Vector2(-1078, 282), 0.5)
	tween.parallel().tween_property($Face, "modulate:a", 0, 0.5)
	
	tween.parallel().tween_property($Blackjack, "position", Vector2(200, 243), 0.5)
	tween.parallel().tween_property($Blackjack, "modulate:a", 1, 0.5)
	
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	
	tween.play()

func vignette(color: Color):
	color_rect.material.set("shader_parameter/vignette_rgb", color)
	
	color_rect.material.set("shader_parameter/vignette_intensity", 2.895)
	await get_tree().create_timer(0.5).timeout
	color_rect.material.set("shader_parameter/vignette_intensity", 0)
	await get_tree().create_timer(0.5).timeout
	color_rect.material.set("shader_parameter/vignette_intensity", 2.895)
	await get_tree().create_timer(0.5).timeout
	color_rect.material.set("shader_parameter/vignette_intensity", 0)
	await get_tree().create_timer(0.5).timeout
