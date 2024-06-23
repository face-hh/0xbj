extends Sprite2D

class_name Face
const BRUH = preload("res://Assets/OC/bruh.png")
const explaining2 = preload("res://Assets/OC/explaining2.png")
const explaining3 = preload("res://Assets/OC/explaining3.png")
const explaining4 = preload("res://Assets/OC/explaining4.png")
const EXPLAINING = preload("res://Assets/OC/explaining.png")
const FACEPALM = preload("res://Assets/OC/facepalm.png")
const POINTING = preload("res://Assets/OC/pointing.png")
const SHRUG = preload("res://Assets/OC/shrug.png")
const THINKING = preload("res://Assets/OC/thinking.png")
const THUMBSUP = preload("res://Assets/OC/thumbsup.png")
const WELL = preload("res://Assets/OC/well.png")
const YOU = preload("res://Assets/OC/you.png")
const STARE = preload("res://Assets/OC/stare.png")

const POSITIONS = {
	"bruh": { "resource": BRUH, "pos": Vector2(0, 0) },
	"stare": { "resource": STARE, "pos": Vector2(0, 0) },
	"explaining": { "resource": EXPLAINING, "pos": Vector2(0, 0) },
	"explaining_2": { "resource": explaining2, "pos": Vector2(0, 0) },
	"explaining_3": { "resource": explaining3, "pos": Vector2(0, 0) },
	"explaining_4": { "resource": explaining4, "pos": Vector2(0, 0) },
	"facepalm": { "resource": FACEPALM, "pos": Vector2(10.5, 0) },
	"pointing": { "resource": POINTING, "pos": Vector2(310, 0) },
	"shrug": { "resource": SHRUG, "pos": Vector2(207, 0) },
	"thinking": { "resource": THINKING, "pos": Vector2(89.345, 0) },
	"thumbsup": { "resource": THUMBSUP, "pos": Vector2(0, 0) },
	"well": { "resource": WELL, "pos": Vector2(20, 0) },
	"you": { "resource": YOU, "pos": Vector2(-88.31, 0) },
}

@onready var global_collision: CollisionPolygon2D = CollisionPolygon2D.new()
@onready var collisions: Area2D = %Area2D

func _process(delta) -> void:
	if Input.is_action_just_pressed("test"):
		change_to(POSITIONS.keys().pick_random())

func _physics_process(_delta: float) -> void:
	_update_click_polygon()

func _update_click_polygon() -> void:
	var click_polygon: PackedVector2Array = global_collision.polygon

	for vec_i in range(click_polygon.size()):
		var local_point: Vector2 = click_polygon[vec_i]
		var global_point: Vector2 = global_collision.to_global(local_point)
		click_polygon[vec_i] = global_point

	get_window().mouse_passthrough_polygon = click_polygon

func change_to(oc: String) -> void:
	print(oc)
	texture = POSITIONS[oc].resource
	position = POSITIONS[oc].pos
