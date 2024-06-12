@tool
extends Node2D

# Regenerate Collision Nodes On Click in Inspector
@export var recalculate_geometry : bool :
	set(_value):
		_create_polygon2d_nodes_from_sprite2d()

@export var tolerance : float = 4.0 # Simplification tolerance
@onready var sprite: Sprite2D = %Sprite2D

func _create_polygon2d_nodes_from_sprite2d() -> void:
	var image: Image = sprite.texture.get_image()
	var bitmap: BitMap = BitMap.new()
	
	bitmap.create_from_image_alpha(image)

	# Convert Bitmap to Polygons
	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, image.get_size()), 0.0)

	# Simplify polygons
	var simplified_polys = []
	
	for poly in polys:
		simplified_polys.append(_simplify_polygon(poly, tolerance))

	# Create CollisionPolygon2D Nodes from Polygons
	for poly in simplified_polys:
		var collision_polygon: CollisionPolygon2D = CollisionPolygon2D.new()
		collision_polygon.polygon = poly
		collision_polygon.name = sprite.texture.resource_path.split("/")[-1]
		
		$Area2D.add_child(collision_polygon)
		collision_polygon.set_owner(get_tree().get_edited_scene_root())
		collision_polygon.position -= sprite.texture.get_size() / 2

# Simplify a polygon using the Ramer-Douglas-Peucker algorithm
func _simplify_polygon(points, tolerance) -> Array:
	if points.size() < 3:
		return points
	
	var start_index: int = 0
	var end_index: int = points.size() - 1
	var stack: Array = [[start_index, end_index]]
	var result: Array = [points[start_index]]
	
	while stack.size() > 0:
		var indices: Array = stack.pop_back()
		var max_distance: int = 0
		var index: int = indices[0]
		
		for i in range(indices[0] + 1, indices[1]):
			var line_start: Vector2 = points[indices[0]]
			var line_end: Vector2 = points[indices[1]]
			
			var distance: float = _perpendicular_distance(points[i], line_start, line_end)
			
			if distance > max_distance:
				index = i
				max_distance = distance
		
		if max_distance > tolerance:
			stack.push_back([indices[0], index])
			stack.push_back([index, indices[1]])
		else:
			result.append(points[indices[1]])
	
	return result

# Calculate the perpendicular distance from a point to a line
func _perpendicular_distance(point, line_start, line_end) -> float:
	var dx: float = line_end.x - line_start.x
	var dy: float = line_end.y - line_start.y
	var mag: float = sqrt(dx * dx + dy * dy)
	
	if mag > 0.0:
		dx /= mag
		dy /= mag
	
	var pvx: float = point.x - line_start.x
	var pvy: float = point.y - line_start.y
	var pvdot: float = dx * pvx + dy * pvy
	var ax: float = pvx - pvdot * dx
	var ay: float = pvy - pvdot * dy
	
	return sqrt(ax * ax + ay * ay)
