extends Node2D
class_name Card

const BACK = preload("res://Assets/Cards/back.png")
const CLOVER_2 = preload("res://Assets/Cards/clover_2.png")
const CLOVER_3 = preload("res://Assets/Cards/clover_3.png")
const CLOVER_4 = preload("res://Assets/Cards/clover_4.png")
const CLOVER_5 = preload("res://Assets/Cards/clover_5.png")
const CLOVER_6 = preload("res://Assets/Cards/clover_6.png")
const CLOVER_7 = preload("res://Assets/Cards/clover_7.png")
const CLOVER_8 = preload("res://Assets/Cards/clover_8.png")
const CLOVER_9 = preload("res://Assets/Cards/clover_9.png")
const CLOVER_10 = preload("res://Assets/Cards/clover_10.png")
const CLOVER_ACE = preload("res://Assets/Cards/clover_ace.png")
const DIAMOND_2 = preload("res://Assets/Cards/diamond_2.png")
const DIAMOND_3 = preload("res://Assets/Cards/diamond_3.png")
const DIAMOND_4 = preload("res://Assets/Cards/diamond_4.png")
const DIAMOND_5 = preload("res://Assets/Cards/diamond_5.png")
const DIAMOND_6 = preload("res://Assets/Cards/diamond_6.png")
const DIAMOND_7 = preload("res://Assets/Cards/diamond_7.png")
const DIAMOND_8 = preload("res://Assets/Cards/diamond_8.png")
const DIAMOND_9 = preload("res://Assets/Cards/diamond_9.png")
const DIAMOND_10 = preload("res://Assets/Cards/diamond_10.png")
const DIAMOND_ACE = preload("res://Assets/Cards/diamond_ace.png")
const DIAMOND_JACK = preload("res://Assets/Cards/diamond_jack.png")
const HEART_2 = preload("res://Assets/Cards/heart_2.png")
const HEART_3 = preload("res://Assets/Cards/heart_3.png")
const HEART_4 = preload("res://Assets/Cards/heart_4.png")
const HEART_5 = preload("res://Assets/Cards/heart_5.png")
const HEART_6 = preload("res://Assets/Cards/heart_6.png")
const HEART_7 = preload("res://Assets/Cards/heart_7.png")
const HEART_8 = preload("res://Assets/Cards/heart_8.png")
const HEART_9 = preload("res://Assets/Cards/heart_9.png")
const HEART_10 = preload("res://Assets/Cards/heart_10.png")
const HEART_ACE = preload("res://Assets/Cards/heart_ace.png")
const JACK = preload("res://Assets/Cards/jack.png")
const KING = preload("res://Assets/Cards/king.png")
const QUEEN = preload("res://Assets/Cards/queen.png")
const SPADE_2 = preload("res://Assets/Cards/spade_2.png")
const SPADE_3 = preload("res://Assets/Cards/spade_3.png")
const SPADE_4 = preload("res://Assets/Cards/spade_4.png")
const SPADE_5 = preload("res://Assets/Cards/spade_5.png")
const SPADE_6 = preload("res://Assets/Cards/spade_6.png")
const SPADE_7 = preload("res://Assets/Cards/spade_7.png")
const SPADE_8 = preload("res://Assets/Cards/spade_8.png")
const SPADE_9 = preload("res://Assets/Cards/spade_9.png")
const SPADE_10 = preload("res://Assets/Cards/spade_10.png")
const SPADE_ACE = preload("res://Assets/Cards/spade_ace.png")

const SPADES = {
  "2": SPADE_2, "3": SPADE_3, "4": SPADE_4, "5": SPADE_5, "6": SPADE_6, 
  "7": SPADE_7, "8": SPADE_8, "9": SPADE_9, "10": SPADE_10, "J": JACK, 
  "Q": QUEEN, "K": KING, "A": SPADE_ACE 
};

const CLOVERS = {
  "2": CLOVER_2, "3": CLOVER_3, "4": CLOVER_4, "5": CLOVER_5, "6": CLOVER_6, 
  "7": CLOVER_7, "8": CLOVER_8, "9": CLOVER_9, "10": CLOVER_10, "J": JACK, 
  "Q": QUEEN, "K": KING, "A": CLOVER_ACE 
};

const DIAMONDS = {
  "2": DIAMOND_2, "3": DIAMOND_3, "4": DIAMOND_4, "5": DIAMOND_5, "6": DIAMOND_6, 
  "7": DIAMOND_7, "8": DIAMOND_8, "9": DIAMOND_9, "10": DIAMOND_10, "J": JACK, 
  "Q": QUEEN, "K": KING, "A": DIAMOND_ACE 
};

const HEARTS = {
  "2": HEART_2, "3": HEART_3, "4": HEART_4, "5": HEART_5, "6": HEART_6, 
  "7": HEART_7, "8": HEART_8, "9": HEART_9, "10": HEART_10, "J": JACK, 
  "Q": QUEEN, "K": KING, "A": HEART_ACE 
};

const POSSIBLE_CARDS = [
  "S2", "S3", "S4", "S5", "S6", "S7", "S8", "S9", "S10", "J", "Q", "K", "SA", 
  "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10", "J", "Q", "K", "CA", 
  "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "J", "Q", "K", "DA", 
  "H2", "H3", "H4", "H5", "H6", "H7", "H8", "H9", "H10", "J", "Q", "K", "HA"
];

@onready var sprite_2d = $Sprite2D
@onready var texture = BACK;
@onready var reveal_player = $RevealPlayer
@onready var label = $Sprite2D/Label

signal proceed

var card_value: String

func _ready():
	visible = false
	sprite_2d.texture = texture
	label.hide()

func hide_label():
	label.hide()

func show_value(show: bool, dealer: bool = false, new: bool = true):
	var _texture

	if not show and not dealer:
		label.text = str(Utils.score_from(card_value))
		_texture = BACK
		label.show()
	elif not show and dealer:
		_texture = BACK
	elif show:
		_texture = texture
	
	if new:
		reveal_player.play("reveal")
	else:
		reveal_player.play("reveal_full")
	
	await proceed
	visible = true
	sprite_2d.texture = _texture

func reveal_finished() -> void:
	proceed.emit()

func assign_value(card: String):
	var value = card.erase(0)
	
	if card == "J": texture = JACK
	if card == "K": texture = KING
	if card == "Q": texture = QUEEN
	if card.begins_with("S"): texture = SPADES[value]
	if card.begins_with("C"): texture = CLOVERS[value]
	if card.begins_with("D"): texture = DIAMONDS[value]
	if card.begins_with("H"): texture = HEARTS[value]
	
	card_value = card
	

