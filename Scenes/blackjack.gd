extends Node2D

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

var gamedata = {
	"dealer": [],
	"player": [],
	"win_at": 21
}

func _ready():
	float_all()
	
	floating_player.play("floating")
	
	init_game()

func init_game():
	var dealer_card1 = random_card()
	var dealer_card2 = random_card()
	
	var player_card1 = random_card()
	
	at("d", 0, dealer_card1, true)
	at("d", 1, dealer_card2, false)
	at("p", 0, player_card1, true)

func reveal_all() -> void:
	for card in cards:
		card.get_node("RevealPlayer").play("reveal")

func at(what: String, index: int, card: String, show: bool, update: bool = true):
	if what == "d":
		dealer_cards[index].assign_value(card)
		dealer_cards[index].show_card(show)
		gamedata.dealer.append(card)
		
		if !update: return
		
		label_player.play("increase_dealer")
		dealer_score.text = str(score_from(gamedata.dealer[0]))
	else:
		player_cards[index].assign_value(card)
		player_cards[index].show_card(show)
		gamedata.player.append(card)
		
		label_player.play("increase_player")
		player_score.text = str(get_score("p"))

func win(what: String):
	result_label.text = "I win." if what == "d" else "You win."
	result_label.show()
	
	hit_button.disabled = true
	stay_button.disabled = true

func get_cards() -> Array[Card]:
	var cards: Array[Card] = []
	
	cards.append_array($Dealer.get_children())
	cards.append_array($Player.get_children())
	
	return cards

func float_all():
	for card in cards:
		card.get_node("FloatingPlayer").play("floating")

func random_card() -> String:
	var blacklisted = []
	
	for card in gamedata.dealer:
		blacklisted.append(card)
	for card in gamedata.player:
		blacklisted.append(card)
	
	var card = null;
	
	while(card == null or blacklisted.has(card)):
		card = Card.POSSIBLE_CARDS.pick_random()
	
	return card

func get_score(who: String) -> int:
	var cards = gamedata.player if who == "p" else gamedata.dealer
	var score = 0
	
	for card in cards:
		score += score_from(card)

	return score

func score_from(card: String) -> int:
	var rank = card.substr(1, card.length() - 1)
	var score = 0
	
	if card in ["J", "Q", "K"]:
		score += 10
	elif rank == "A":
		score += 1
	else:
		score += int(rank) # Cards 2-10 have their face value
	
	return score

func _on_hit_button_pressed():
	at("p", gamedata.player.size(), random_card(), true)
	hit_player.play("hit")
	
	var score = get_score("p")
	
	if score > gamedata.win_at:
		no_longer_hit = true
		hit_button.disabled = true
	elif score == gamedata.win_at:
		no_longer_hit = true
		hit_button.disabled = true

func _on_stay_button_pressed():
	dealer_cards[1].show_card(true)

	label_player.play("increase_dealer")
	dealer_score.text = str(get_score("d"))
	
	at("d", 2, random_card(), false, false)
	
	await get_tree().create_timer(1.5).timeout
	dealer_cards[2].show_card(true)
	label_player.play("increase_dealer")
	
	var dealer_score_final = get_score("d");
	
	dealer_score.text = str(dealer_score_final)
	
	if dealer_score_final > 21:
		win("p")
	elif dealer_score_final == 21:
		win("d")
	elif dealer_score_final > get_score("p"):
		win("d")
	else:
		win("p")
