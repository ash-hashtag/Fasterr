extends StaticBody

onready var cam = $Camera
onready var handlehandle = $Spatial
onready var handle = $Spatial/cam_handle
onready var player = $car
var top_down_view = false


func _physics_process(delta):
	if top_down_view:
		cam.global_transform.origin = Vector3(player.global_transform.origin.x, 20, player.global_transform.origin.z)
	else:
		handlehandle.global_transform = player.global_transform
		cam.global_transform = handle.global_transform

func _input(event):
	if event.is_action_pressed("cam_view"):
		if top_down_view:
			top_down_view = false
		else:
			top_down_view = true
			cam.rotation_degrees.x = -90
