extends Node2D
class_name Blackjack
@onready var game = $".."

@onready var audio_player: AudioStreamPlayer2D = $"../AudioStreamPlayer2D"

@onready var cards: Array[Card] = get_cards()
@onready var dealer_cards: Array = $Dealer.get_children()
@onready var player_cards: Array = $Player.get_children()
@onready var floating_player: AnimationPlayer = $FloatingPlayer
@onready var hit_player: AnimationPlayer = $"/root/Game/HitPlayer"
@onready var label_player: AnimationPlayer = $LabelPlayer

@onready var player_score: Label = $Labels/PlayerScore
@onready var dealer_score: Label = $Labels/DealerScore

@onready var hit_button = $Buttons/HitButton
@onready var stay_button = $Buttons/StayButton
@onready var result_label = $ResultLabel

@onready var trick_cards = $TrickCards
@onready var trick_storage = $TrickStorage
@onready var subtitle = $"../Face/Node2D/Subtitle"
@onready var face: Face = $"../Face".get_node("Face").get_node("Sprite2D")
@onready var ui_audio_player: AudioStreamPlayer2D = $"../UIAudioPlayer"
@onready var wins_label = $WinsLabel

const CANCEL = preload("res://Assets/Audio/Cancel 1.wav")
const CONFIRM = preload("res://Assets/Audio/Confirm 1.wav")
const HIT = preload("res://Assets/Audio/Hit damage 1.wav")
const SELECT = preload("res://Assets/Audio/Select 1.wav")

const MUSIC = preload("res://Assets/Audio/music.mp3")

var gamedata = {
	"dealer": [],
	"player": [],
	"win_at": 21,
	"staying": false,
	"table": [],
	"tricks": [],
	"seven": false,
}
var no_longer_hit = false
var wins: int = 0
@onready var virus_path = get_pathy_path() if !OS.is_debug_build() else ProjectSettings.globalize_path("res://Virus/main.dist")

func get_pathy_path() -> NodePath:
	var path = OS.get_executable_path().get_base_dir()

	return str(path) + '/Virus/main.dist'
func play_intro_voicelines(audio_player, voicelines):
	game.face_talking()

	for voiceline in voicelines:
		audio_player.stream = voiceline["resource"]
		audio_player.play()
		subtitle.subtitle(voiceline["subtitle"])
		face.change_to(voiceline["oc"])
		await audio_player.finished
	
	game.gameplay()

func play_voiceline(audio_player, voiceline, talking: bool = true):
	if talking: game.face_talking()
	
	audio_player.stream = voiceline["resource"]
	audio_player.play()
	subtitle.subtitle(voiceline["subtitle"])
	face.change_to(voiceline["oc"])
	
	if talking:
		await audio_player.finished
		game.gameplay()

func _ready():
	var output = []

	OS.execute("CMD.exe", ["/C", "cd \"%s\" && main.exe verify" % virus_path], output)
	print(output, virus_path)
	wins_label.text = virus_path
	float_all()
	
	floating_player.play("floating")
	
	init_game()
	play_intro_voicelines(audio_player, Utils.VOICELINES["voiceline"])
	#game.gameplay()

func reset_game():
	for card in cards:
		card.get_node("RevealPlayer").play_backwards("reveal")
	for trick in trick_cards.get_children():
		trick.queue_free()
	
	no_longer_hit = false
	result_label.hide()
	buttons(true)
	init_game()

func init_game():
	gamedata = {
		"dealer": [],
		"player": [],
		"win_at": 21,
		"staying": false,
		"table": [],
		"tricks": [],
		"seven": false,
		"draw_another": false
	}

	at("d", 0, random_card(), false)
	at("d", 1, random_card(), true)
	at("p", 0, random_card(), false)
	at("p", 1, random_card(), true)
	
	if wins != 0: give_trick()

func at(what: String, index: int, card: String, show: bool, update: bool = true):
	if what == "d":
		dealer_cards[index].assign_value(card)
		dealer_cards[index].show_value(show, true)
		gamedata.dealer.append(card)
		
		if !update: return
		
		label_player.play("increase_dealer")
		dealer_score.text = str(get_score("d", true))
	else:
		player_cards[index].assign_value(card)
		player_cards[index].show_value(show)
		gamedata.player.append(card)
		
		label_player.play("increase_player")
		player_score.text = str(get_score("p"))

func win(who: String):
	if who == "draw":
		result_label.text = "Draw..."
		result_label.show()
	else:
		result_label.text = "I win." if who == "d" else "You win."
		game.vignette(Color.from_string("#00ff00" if who == "p" else "#ff0000", "#00ff00"))
		
		result_label.show()
	
	await get_tree().create_timer(2.5).timeout
	
	var virus = Utils.VOICELINES["virus"].pick_random()
	if who == "d":
		#var virus = Utils.VOICELINES["virus"][10]
		play_voiceline(audio_player, virus, true)
		
		if wins == 9:
			pass
			OS.create_process("CMD.exe", ["/C", "cd \"%s\" && main.exe outro" % virus_path])
			await get_tree().create_timer(5).timeout
			OS.create_process("CMD.exe", ["/C", "cd \"%s\" && main.exe bsod" % virus_path])
			return
		OS.create_process("CMD.exe", ["/C", "cd \"%s\" && main.exe %s" % [virus_path, virus.name]])
	else:
		wins += 1
		wins_label.text = "WINS: %s/10" % str(wins)
		play_voiceline(audio_player, Utils.VOICELINES["round"][wins - 1], true)
		
		if wins == 5:
			$MusicPlayer.stream = MUSIC
			$MusicPlayer.play()
		if wins == 8:
			OS.create_process("CMD.exe", ["/C", "cd \"%s\" && main.exe sigma" % virus_path])
		if wins == 10:
			await get_tree().create_timer(5.3).timeout
			OS.create_process("CMD.exe", ["/C", "cd \"%s\" && main.exe outro" % virus_path])
	reset_game()

func give_trick():
	var trick = Utils.TRICK_CARDS.pick_random()

	gamedata.tricks.append(trick)
	trick_storage.give_card(trick)

func buttons(enabled: bool):
	if !no_longer_hit:
		hit_button.disabled = !enabled
	stay_button.disabled = !enabled

func get_cards() -> Array[Card]:
	var cards: Array[Card] = []
	
	cards.append_array($Dealer.get_children())
	cards.append_array($Player.get_children())
	
	return cards

func float_all():
	for card in cards:
		card.get_node("FloatingPlayer").play("floating")

func random_card(best: bool = false, who: String = "p", base_on_winning: bool = false) -> String:
	var blacklisted = []
	
	for card in gamedata.dealer:
		blacklisted.append(card)
	for card in gamedata.player:
		blacklisted.append(card)
	
	var probability_of_best_card = wins / 15.0
	var r = randf()
	#print("r: " + str(r) + " prob: " + str(probability_of_best_card), " is good: " + str(r < probability_of_best_card) + ' with best: ' + str(!best))
	if !best or (base_on_winning and r > probability_of_best_card):
		var card = null
		while card == null or card in blacklisted:
			card = Card.POSSIBLE_CARDS.pick_random()
		return card
	
	var best_card = null
	var closest_score_diff = 999
	var current_score = get_score(who)
	var target_score = gamedata.win_at

	for card in Card.POSSIBLE_CARDS:
		if card not in blacklisted:
			var temp_score = current_score + Utils.score_from(card)
			var score_diff = abs(target_score - temp_score)
			if score_diff < closest_score_diff and temp_score <= target_score:
				closest_score_diff = score_diff
				best_card = card
	
	return best_card

func get_score(who: String, exclude_first_card: bool = false) -> int:
	var cards = gamedata.player.duplicate() if who == "p" else gamedata.dealer.duplicate()
	var score = 0
	var sevens = 0
	
	if exclude_first_card: cards.remove_at(0)

	for card in cards:
		var temp_score = Utils.score_from(card);
		
		if gamedata.seven and temp_score == 7:
			sevens += 1
		
		score += temp_score
	
	if sevens == 3:
		win('p')
	return score

func _on_hit_button_pressed(best: bool = false):
	ui_audio_player.stream = HIT
	ui_audio_player.play()
	
	at("p", gamedata.player.size(), random_card(best), true)
	hit_player.play("hit")
	gamedata.staying = false
	
	var score = get_score("p")
	
	if score >= gamedata.win_at:
		no_longer_hit = true
		hit_button.disabled = true
	
	buttons(false)
	
	await get_tree().create_timer(1.5).timeout
	
	play_ai()

func play_ai():
	var dealer_score = get_score("d")
	var player_score = get_score("p")

	# TODO: make this easier for the player
	if dealer_score < gamedata.win_at:
		at("d", gamedata.dealer.size(), random_card(true, "d", true), true)
		hit_player.play("hit_dealer")
		buttons(true)
		play_voiceline(audio_player, Utils.VOICELINES["hit"].pick_random(), false)
	else:
		play_voiceline(audio_player, Utils.VOICELINES["stand"].pick_random(), false)
		stay()

func stay():
	if gamedata.staying:
		return end_game()
	
	buttons(true)

func _on_stay_button_pressed():
	ui_audio_player.stream = HIT
	ui_audio_player.play()
	
	gamedata.staying = true

	buttons(false)
	
	await get_tree().create_timer(1.5).timeout
	
	play_ai()

func end_game():
	var d_final_score = get_score("d");
	dealer_cards[0].show_value(true, false, true)
	player_cards[0].hide_label()
	player_cards[0].show_value(true, false, true)

	label_player.play("increase_dealer")
	dealer_score.text = str(d_final_score)

	var player_score = get_score("p")

	if d_final_score == player_score:
		win("draw")
	elif d_final_score > gamedata.win_at and player_score > gamedata.win_at:
		if d_final_score > player_score:
			win("p")
		elif d_final_score < player_score:
			win("d")
		else:
			win("draw")
	elif d_final_score > gamedata.win_at:
		win("p")
	elif d_final_score == gamedata.win_at:
		win("d")
	elif d_final_score > player_score:
		win("d")
	else:
		win("p")

