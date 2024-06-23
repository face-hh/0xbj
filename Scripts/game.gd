extends Node

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
