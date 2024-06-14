extends Node2D

var past_card = null
const h = 600
var time
var still_pressing = false

func _ready():
	for trickcard in get_children():
		var btn: TextureButton = trickcard.setup_perm()
		
		btn.connect("button_down", func():
			still_pressing = true
			
			await get_tree().create_timer(0.2).timeout
			
			if still_pressing:
				shake(trickcard)
		)
		
		btn.connect("button_up", func():
			still_pressing = false
		)
		
		btn.connect("pressed", func():
			var tween: Tween = get_tree().create_tween()
			
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.set_trans(Tween.TRANS_QUART)
			
			if is_instance_valid(past_card):
				tween.tween_property(past_card, "position:y", past_card.position.y + h, 0.25)

			if trickcard != past_card:
				tween.tween_property(trickcard, "position:y", trickcard.position.y - h, 0.25)
			else:
				past_card = null
				tween.play()
				return
			
			past_card = trickcard
			
			tween.play()
		)

func shake(trickcard: Node2D, duration: float = 0.6, magnitude: float = 30.0):
	var tween: Tween = get_tree().create_tween()

	var original_position = trickcard.position
	var shake_times = int(duration / 0.03)

	for i in range(shake_times):
		var offset = Vector2(
			randi_range(-magnitude, magnitude),
			randi_range(-magnitude, magnitude)
		)
		tween.tween_property(
			trickcard, "position", original_position + offset, 0.05
		)
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.play()
	
	tween.tween_callback(func():
		play_use(trickcard)
	)
	#tween.tween_property(
		#trickcard, "position", original_position, 0.05)
	#tween.set_trans(Tween.TRANS_LINEAR)
	#tween.set_ease(Tween.EASE_IN_OUT)
	#tween.play()

func play_use(trickcard: Node2D):
	if Utils.Types.TABLE == trickcard.type:
		trickcard.move_to()
	else:
		trickcard.get_node("AnimationPlayer").play("use")
