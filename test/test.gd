extends Spatial

onready var line = $CanvasLayer/Line2D
onready var posit = $Position3D
var hitpoint := Vector2.ZERO
var hit := Vector3.ZERO
var scrn_size:= Vector2.ZERO

func _ready():
	scrn_size = get_viewport().size / 2
#	line.global_position = Vector2(global_transform.origin.x, global_transform.origin.y) + scrn_size

func _input(event):
	if event is InputEventMouseButton:
		add_point(event.position)

func _physics_process(delta):
	if hit != Vector3.ZERO:
		posit.global_transform.origin = lerp(posit.global_transform.origin, hit, 2 * delta)
		line.add_point(Vector2(posit.global_transform.origin.x, posit.global_transform.origin.y))
		if (posit.global_transform.origin - hit).length() < 0.1:
			hit = Vector3.ZERO
			posit.global_transform.origin = global_transform.origin
			line.clear_points()
	
	while line.get_point_count() > 10:
		line.remove_point(0)

func add_point(pos: Vector2) -> void:
#	hitpoint = pos
	hit = Vector3(pos.x, pos.y, 5)
