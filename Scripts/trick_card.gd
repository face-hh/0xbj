extends Node2D

var original_size = scale
@export var original_pos: Vector2

var card_info: String = "???"
var type: Utils.Types = Utils.Types.TABLE
var card_index: int = 1

@onready var sprite_2d = $Sprite2D
@onready var label = $Sprite2D2/Label
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d_2 = $Sprite2D2
@onready var texture_button: TextureButton = $Sprite2D/TextureButton

func update_info():
	sprite_2d.texture = Utils.TRICK_CARDS[card_index - 1].resource
	label.text = card_info

func _ready():
	sprite_2d_2.modulate.a = 0

func setup_legacy():
	texture_button.connect("mouse_entered", _on_mouse_entered)
	texture_button.connect("mouse_exited", _on_mouse_exited)

func setup_perm() -> TextureButton:
	texture_button.disconnect("mouse_entered", _on_mouse_entered)
	texture_button.disconnect("mouse_exited", _on_mouse_exited)
	
	return texture_button

func _on_mouse_entered():
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "scale", scale * 1.15, 0.15)
	tween.tween_property(sprite_2d_2, "modulate", Color(255, 255, 255, 1), 0.15)
	tween.play()

func _on_mouse_exited():
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "scale", original_size, 0.15)
	tween.tween_property(sprite_2d_2, "modulate", Color(255, 255, 255, 0), 0.15)
	tween.play()
	tween.tween_callback(func():
		sprite_2d_2.modulate.a = 0
		scale = original_size
	)

func move_to(gamedata):
	var index = gamedata.table.size()
	var data = Utils.TABLE_POS[index]
	
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)

	tween.parallel().tween_property(self, "scale", original_size, 0.15)
	tween.parallel().tween_property(self, "rotation", data.rotation, 0.15)
	tween.parallel().tween_property(self, "position", data.position, 0.15)

	tween.play()
