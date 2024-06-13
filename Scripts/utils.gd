extends Node

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
