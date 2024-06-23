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

@onready var face: Face = $/root/Game/Face.get_node("Face").get_node("Sprite2D")

const VOICELINES = {
	"hit": [
		{ "subtitle": "Ding ding ding ding, gambling a little more.", "resource": preload("res://Assets/Audio/hit1.wav"), "oc": "explaining_2" },
		{ "subtitle": "I'll take another card.", "resource": preload("res://Assets/Audio/hit2.wav"), "oc": "explaining_3" },
		{ "subtitle": "We are SO back.", "resource": preload("res://Assets/Audio/hit3.wav"), "oc": "thumbsup" },
		{ "subtitle": "Cope harder.", "resource": preload("res://Assets/Audio/hit4.wav"), "oc": "bruh" },
		{ "subtitle": "I'm feeling lucky.", "resource": preload("res://Assets/Audio/hit5.wav"), "oc": "stare" },
		{ "subtitle": "Taking my shot.", "resource": preload("res://Assets/Audio/hit6.wav"), "oc": "explaining" },
		{ "subtitle": "Another card, coming up.", "resource": preload("res://Assets/Audio/hit7.wav"), "oc": "thumbsup" },
		{ "subtitle": "Can't win without a little risk.", "resource": preload("res://Assets/Audio/hit8.wav"), "oc": "explaining_4" },
		{ "subtitle": "I'll draw again.", "resource": preload("res://Assets/Audio/hit9.wav"), "oc": "thumbsup" },
	],
	"stand": [
		{ "subtitle": "I'll stand.", "resource": preload("res://Assets/Audio/stand1.wav"), "oc": "thumbsup" },
		{ "subtitle": "Alright, imma fuck off.", "resource": preload("res://Assets/Audio/stand2.wav"), "oc": "bruh" },
		{ "subtitle": "I'm done here.", "resource": preload("res://Assets/Audio/stand3.wav"), "oc": "well" },
		{ "subtitle": "No more for me.", "resource": preload("res://Assets/Audio/stand4.wav"), "oc": "shrug" },
		{ "subtitle": "I'm good with this.", "resource": preload("res://Assets/Audio/stand5.wav"), "oc": "thumbsup" },
		{ "subtitle": "I'll hold here.", "resource": preload("res://Assets/Audio/stand6.wav"), "oc": "bruh" },
		{ "subtitle": "Alright, I'm set.", "resource": preload("res://Assets/Audio/stand7.wav"), "oc": "thumbsup" },
		{ "subtitle": "Waiting on you, pal.", "resource": preload("res://Assets/Audio/stand8.wav"), "oc": "you" },
	],
	"round": [
		{ "subtitle": "Alright. To make the game more fun, here's a Trick Card. It can either stand on the table or be used for a one-time effect. Let's go for the next round.", "resource": preload("res://Assets/Audio/round1.wav"), "oc": "explaining_4" },
		{ "subtitle": "You win! Every round I'll crank the difficulty up, so don't get too confident.", "resource": preload("res://Assets/Audio/round2.wav"), "oc": "you" },
		{ "subtitle": "Alright, you completed 3 rounds. Seven more and you're free to go!", "resource": preload("res://Assets/Audio/round3.wav"), "oc": "thumbsup" },
		{ "subtitle": "Amazing gameplay! Remember what's at stake if you lose.", "resource": preload("res://Assets/Audio/round4.wav"), "oc": "thumbsup" },
		{ "subtitle": "I'm getting bored. Let's get some music playing.", "resource": preload("res://Assets/Audio/round5.wav"), "oc": "thinking" },
		{ "subtitle": "Six rounds in and you're STILL hanging on! How did the game not break yet?", "resource": preload("res://Assets/Audio/round6.wav"), "oc": "stare" },
		{ "subtitle": "That's 3 more rounds to go! Wait or is it 4? I can't count let's just go.", "resource": preload("res://Assets/Audio/round7.wav"), "oc": "explaining_3" },
		{ "subtitle": "Erm, what the sigma? Alright I'm bored so now let's take a break and watch some Sigma edits. I'm gonna block your mouse nad keyboard.", "resource": preload("res://Assets/Audio/round8.wav"), "oc": "bruh" },
		{ "subtitle": "Alright, it's all or nothing. If you lose this time, you will get the \"Blue Screen of Death\". Basically I'll crash your computer. You'd better have stacked up those trick cards 'cause theres no way you're winning.", "resource": preload("res://Assets/Audio/round9.wav"), "oc": "thumbsup" },
		{ "subtitle": "Welp I guess that's it. Thanks for playing, and as always, see you in the next one.", "resource": preload("res://Assets/Audio/round10.wav"), "oc": "shrug" },
	],
	"virus": [
		{ "subtitle": "Ah, too unfortunate. You know what's coming... could you press the Windows and D key to view your desktop?", "resource": preload("res://Assets/Audio/virus1_file_spam.wav"), "oc": "explaining", "name": "files" },
		{ "subtitle": "Yo, can you try to click your mouse?", "resource": preload("res://Assets/Audio/virus3_fart_on_click.wav"), "oc": "explaining_3", "name": "click" },
		{ "subtitle": "And for your punishment... I will UNINSTALL Microsoft Edge.", "resource": preload("res://Assets/Audio/virus4_edge.wav"), "oc": "stare", "name": "edge" },
		{ "subtitle": "Ding ding ding ding! Your PC had an error.", "resource": preload("res://Assets/Audio/virus5_error.wav"), "oc": "bruh", "name": "errors" },
		{ "subtitle": "This is BORING. Let's get some entertainment up.", "resource": preload("res://Assets/Audio/virus6_familyguy.wav"), "oc": "facepalm", "name": "familyguy" },
		{ "subtitle": "Okay, you're advancing way too fast. Your mouse will now move way slower.", "resource": preload("res://Assets/Audio/virus7_slowmouse.wav"), "oc": "well", "name": "slowmouse" },
		{ "subtitle": "All I'm gonna say: Michael was in witness protection.", "resource": preload("res://Assets/Audio/virus8_gtav.wav"), "oc": "explaining_2", "name": "gtav" },
		{ "subtitle": "I can FEEL my receptors frying because of your boring gameplay.", "resource": preload("res://Assets/Audio/virus9_satisfying.wav"), "oc": "bruh", "name": "satisfying" },
		{ "subtitle": "You know what I've realised? You probably aren't subscribed to me on YouTube. Let me change that.", "resource": preload("res://Assets/Audio/virus10_subscribe.wav"), "oc": "thinking", "name": "youtube" },
		{ "subtitle": "Yo, can you press the Windows and D key to view your new wallpaper?", "resource": preload("res://Assets/Audio/virus11_wallpaper.wav"), "oc": "you", "name": "wallpaper" },
		{ "subtitle": "🎵🎵🎵", "resource": preload("res://Assets/Audio/virus12_subway_surfers.wav"), "oc": "explaining_2", "name": "subway" },
		{ "subtitle": "اكفر كفرة هسة يكلولي ليش تكفر", "resource": preload("res://Assets/Audio/virus13_arabic.wav"), "oc": "explaining_3", "name": "arabic" },
	],
	"voiceline": [
		{ "subtitle": "This is a virus. This is your PC, and this is me having complete access to it.", "resource": preload("res://Assets/Audio/voiceline1.wav"), "oc": "pointing" },
		{ "subtitle": "You know how it goes, your files are ENCRYPTED and you have to send me Bitcoin.", "resource": preload("res://Assets/Audio/voiceline2.wav"), "oc": "explaining_4" },
		{ "subtitle": "Oh wait, wrong script.", "resource": preload("res://Assets/Audio/voiceline3.wav"), "oc": "facepalm" },
		{ "subtitle": "You know it goes, you have to win 10 games of Blackjack against me.", "resource": preload("res://Assets/Audio/voiceline4.wav"), "oc": "bruh" },
		{ "subtitle": "You win, you go to the next one. You lose, something will happen to your PC.", "resource": preload("res://Assets/Audio/voiceline5.wav"), "oc": "explaining_3" },
		{ "subtitle": "How exciting!", "resource": preload("res://Assets/Audio/voiceline6.wav"), "oc": "thumbsup" },
		{ "subtitle": "In case you don't know how to play Blackjack, basically your goal is to get as close to \"21\" as possible without going over.", "resource": preload("res://Assets/Audio/voiceline7.wav"), "oc": "explaining_2" },
		{ "subtitle": "Once you feel close enough you can hit \"Stand\". If I also decide to stand, the game ends and we show our cards.", "resource": preload("res://Assets/Audio/voiceline8.wav"), "oc": "explaining" },
		{ "subtitle": "The one closest to 21 wins.", "resource": preload("res://Assets/Audio/voiceline9.wav"), "oc": "well" },
		{ "subtitle": "Most cards have their value written on their face. Jacks, Queens and Kings are valued at 10 and Aces at 1.", "resource": preload("res://Assets/Audio/voiceline10.wav"), "oc": "explaining_4" },
		{ "subtitle": "Alright, let's begin.", "resource": preload("res://Assets/Audio/voiceline11.wav"), "oc": "thumbsup" },
	],
	"bsod": { "subtitle": "Tun tun tun. Game over. You know what's coming.", "resource": preload("res://Assets/Audio/virus2_bsod.wav"), "oc": "facepalm", "name": "bsod" },
}

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
