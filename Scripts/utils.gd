extends Node

const TRICK_24 = preload("res://Assets/Cards/trick_24.png")
const TRICK_27 = preload("res://Assets/Cards/trick_27.png")
const TRICK_777 = preload("res://Assets/Cards/trick_777.png")
const TRICK_BEST_CARD = preload("res://Assets/Cards/trick_best_card.png")
const TRICK_DESTROY_RECENT_CARD = preload("res://Assets/Cards/trick_destroy_recent_card.png")
const TRICK_NEW_CARD_ON_CARD = preload("res://Assets/Cards/trick_new_card_on_card.png")
const TRICK_REMOVE_ALL_TRICK_CARDS = preload("res://Assets/Cards/trick_remove_all_trick_cards.png")
const TRICK_SWAP = preload("res://Assets/Cards/trick_swap.png")

enum Types { TABLE, ONETIME }

const TRICK_CARDS = [
	{ "index": 1, "type": Types.TABLE, "description": "The game ends at 24 instead of 21.", "resource": TRICK_24 },
	{ "index": 2, "type": Types.TABLE, "description": "The game ends at 27 instead of 21.", "resource": TRICK_27 },
	{ "index": 3, "type": Types.TABLE, "description": "First to get THREE cards of 7 win.", "resource": TRICK_777 },
	{ "index": 4, "type": Types.ONETIME, "description": "Get 2 trick cards", "resource": TRICK_NEW_CARD_ON_CARD },
	{ "index": 5, "type": Types.ONETIME, "description": "Draw the best card possible for you.", "resource": TRICK_BEST_CARD },
	{ "index": 6, "type": Types.ONETIME, "description": "Destroy your opponent's latest card.", "resource": TRICK_DESTROY_RECENT_CARD },
	{ "index": 7, "type": Types.ONETIME, "description": "Remove all active Trick cards.", "resource": TRICK_REMOVE_ALL_TRICK_CARDS },
	{ "index": 8, "type": Types.ONETIME, "description": "Swap your most recent card with the opponent's.", "resource": TRICK_SWAP },
]

const TABLE_POS = [
	{ "position": Vector2(172, 567.4), "rotation": deg_to_rad(-8.5) },
	{ "position": Vector2(375, 570.4), "rotation": deg_to_rad(15.5) },
	{ "position": Vector2(565, 575.4), "rotation": deg_to_rad(0) },
	{ "position": Vector2(770, 585.4), "rotation": deg_to_rad(8) }
]

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
