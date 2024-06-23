extends Node2D

var past_card = null
const h = 600
var time
var still_pressing = false
var ignore_upcoming = false
@onready var blackjack = $".."
@onready var ui_audio_player = $/root/Game/UIAudioPlayer

const TRICK_CARD = preload("res://Scenes/trick_card.tscn")

const SELECT = preload("res://Assets/Audio/Select 1.wav")
const CANCEL = preload("res://Assets/Audio/Cancel 1.wav")
const CONFIRM = preload("res://Assets/Audio/Confirm 1.wav")

var connections = {}

func apply_signals(trickcard):
	var btn: TextureButton = trickcard.setup_perm()
	
	var down_func = func() -> void:
		_on_button_down(trickcard)
	var up_func = func() -> void:
		_on_button_up()
	var pressed_func = func() -> void:
		_on_pressed(trickcard)
	
	btn.connect("button_down", down_func)
	btn.connect("button_up", up_func)
	btn.connect("pressed", pressed_func)
		
	connections[trickcard] = {
		"button_down": down_func,
		"button_up": up_func,
		"pressed": pressed_func
	}

func give_card(which):
	var node = TRICK_CARD.instantiate()
	
	node.card_info = which.description
	node.type = which.type
	node.card_index = which.index
	node.position = Vector2(0, -1200)
	
	var tween: Tween = get_tree().create_tween()

	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(node, "position", Vector2(0, get_children().size() * 35), 0.50)
	
	add_child(node)
	tween.play()
	node.update_info()
	apply_signals(node)

func remove_connections(trickcard):
	if trickcard in connections:
		var btn: TextureButton = trickcard.get_node("Sprite2D").get_node("TextureButton")
		btn.disconnect("button_down", connections[trickcard]["button_down"])
		btn.disconnect("button_up", connections[trickcard]["button_up"])
		btn.disconnect("pressed", connections[trickcard]["pressed"])
		
		if past_card == trickcard:
			past_card = null
		
		connections.erase(trickcard)
	
	trickcard.setup_legacy()

func _on_pressed(trickcard):
	if ignore_upcoming:
		ignore_upcoming = false
		return
	ui_audio_player.stream = SELECT
	ui_audio_player.play()
	var tween: Tween = get_tree().create_tween()

	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)

	if is_instance_valid(past_card):
		tween.parallel().tween_property(past_card, "position:y", past_card.position.y + h, 0.25)
		past_card.get_node("AnimationPlayer").play_backwards("info")

	if trickcard != past_card:
		tween.parallel().tween_property(trickcard, "position:y", trickcard.position.y - h, 0.25)
		trickcard.get_node("AnimationPlayer").play("info")
	else:
		ui_audio_player.stream = CANCEL
		ui_audio_player.play()
		past_card = null
		tween.play()
		return
	
	past_card = trickcard
	
	tween.play()

func _on_button_down(trickcard):
	still_pressing = true
	
	await get_tree().create_timer(0.2).timeout
	
	if still_pressing:
		trickcard.get_node("AnimationPlayer").play_backwards("info")
		ignore_upcoming = true
		shake(trickcard)

func _on_button_up():
	still_pressing = false

func shake(trickcard: Node2D, duration: float = 0.6, magnitude: float = 30.0):
	var tween: Tween = get_tree().create_tween()

	var original_position = trickcard.position
	var shake_times = int(duration / 0.03)

	for i in range(shake_times):
		if not still_pressing:
			past_card = trickcard
			trickcard.position = original_position
			trickcard.get_node("AnimationPlayer").play("info")
			break
		
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
		if still_pressing:
			play_use(trickcard)
	)
	#tween.tween_property(
		#trickcard, "position", original_position, 0.05)
	#tween.set_trans(Tween.TRANS_LINEAR)
	#tween.set_ease(Tween.EASE_IN_OUT)
	#tween.play()

func play_use(trickcard: Node2D):
	ui_audio_player.stream = CONFIRM
	ui_audio_player.play()
	var i = trickcard.card_index;
	
	if Utils.Types.TABLE == trickcard.type:
		trickcard.reparent($"../TrickCards")
		trickcard.move_to(blackjack.gamedata)
		blackjack.gamedata.table.append(trickcard.card_index)
		await get_tree().create_timer(0.3).timeout
		remove_connections(trickcard)
		
		if i == 1:
			blackjack.gamedata.win_at = 24
		if i == 2:
			blackjack.gamedata.win_at = 27
		if i == 3:
			blackjack.gamedata.seven = true
	else:
		trickcard.get_node("AnimationPlayer").play("use")
		
		if i == 4:
			blackjack.give_trick()
			blackjack.give_trick()
		if i == 5:
			blackjack._on_hit_button_pressed(true)
		if i == 6:
			var index = blackjack.gamedata.dealer.size() - 1
			
			blackjack.gamedata.dealer.remove_at(index)
			blackjack.dealer_cards[index].get_node("RevealPlayer").play_backwards("reveal")
			blackjack.label_player.play("increase_dealer")
			blackjack.dealer_score.text = str(blackjack.get_score("d", true))
		if i == 7:
			var tween = get_tree().create_tween()
			
			tween.set_trans(Tween.TRANS_LINEAR)
			tween.set_ease(Tween.EASE_IN_OUT)
			
			for trick_on_table in blackjack.trick_cards.get_children():
				tween.tween_property(trick_on_table, "position", Vector2(trick_on_table.position.x, -1200), 0.15)
			
			tween.play()
			tween.tween_callback(func():
				for trick_on_table in blackjack.trick_cards.get_children():
					trick_on_table.queue_free()
				
				blackjack.gamedata.seven = false
				blackjack.gamedata.win_at = 21
			)
		if i == 8:
			var p_index = blackjack.gamedata.player.size() - 1
			var d_index = blackjack.gamedata.dealer.size() - 1
			
			var dealer_card = blackjack.gamedata.dealer[d_index]
			var player_card = blackjack.gamedata.player[p_index]
			
			blackjack.gamedata.player[p_index] = dealer_card
			blackjack.gamedata.dealer[d_index] = player_card
			
			blackjack.dealer_cards[d_index].assign_value(player_card)
			blackjack.dealer_cards[d_index].show_value(true, false, false)
			blackjack.label_player.play("increase_dealer")
			blackjack.dealer_score.text = str(blackjack.get_score("d", true))
			
			blackjack.player_cards[p_index].assign_value(dealer_card)
			blackjack.player_cards[p_index].show_value(true, false, false)
			blackjack.label_player.play("increase_player")
			blackjack.player_score.text = str(blackjack.get_score("p"))
