extends Spatial

export var FIRERATE = (6.0/ 6.0)

var hitpoint := Vector3.ZERO

onready var timer = $Timer
onready var raycast = $RayCast
onready var particles = $Particles
onready var crosshair = $CanvasLayer/Sprite3D
onready var travelpoint = $CanvasLayer/Position3D
onready var line = $CanvasLayer/Line2D

func _ready():
	timer.wait_time = FIRERATE
	
func _physics_process(delta):
	if raycast.is_colliding():
		hitpoint = raycast.get_collision_point()
		crosshair.global_transform.origin = lerp(crosshair.global_transform.origin, hitpoint - global_transform.basis.z, 16 * delta)
	else:
		crosshair.global_transform.origin = lerp(crosshair.global_transform.origin, global_transform.origin + global_transform.basis.z * 20, 16 * delta)
	
	if hitpoint != Vector3.ZERO:
		travelpoint.global_transform.origin = lerp(travelpoint.global_transform.origin, hitpoint, 2 * delta)
		line.add_point(Vector2(travelpoint.global_transform.origin.x, travelpoint.global_transform.origin.y))
		while line.get_point_count() > 10:
			line.remove_point(0)
		if (travelpoint.global_transform.origin - hitpoint).length() < 0.1: 
			line.clear_points()
			hitpoint = Vector3.ZERO
			travelpoint.global_transform.origin = global_transform.origin

func _input(event):
	if event.is_action("fire"):
		if timer.is_stopped():
			timer.start()
			_on_Timer_timeout()
		else:
			timer.stop()
			particles.emitting = false

func _on_Timer_timeout():
	var obj = raycast.get_collider()
	if obj:
		particles.global_transform.origin = raycast.get_collision_point()
		if !particles.emitting: particles.emitting = true
	elif particles.emitting: particles.emitting = false
