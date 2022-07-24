extends VehicleBody

const max_torque = 800
const max_rpm = 1000
const brake_force = 20

onready var back_wheels = [get_node("back_left"), get_node("back_right")]
onready var initpos = global_transform.origin

var cam_first = true

func _physics_process(delta):
	steering = lerp(steering, Input.get_axis("right", "left") * 0.4, 5 * delta)
	if Input.is_action_pressed("space"):
		brake = brake_force
	elif brake != 0:
		brake = 0
	for wheel in back_wheels:
		wheel.engine_force = Input.get_axis("backward", "forward") * max_torque * (1 - wheel.get_rpm() / max_rpm)
#	if Input.is_action_just_pressed("cam_view"):
#		if cam_first:
#			cam_first = false
#			cam.look_at(transform.origin)
#		else:
#			cam_first = true
#
#func cam_movement() -> void:
#	if cam_first:
#		cam.transform = campos.transform
#	else:
#		cam.transform.origin = Vector3(transform.origin.x, 20, transform.origin.z)


var flipped: = false
func _on_Timer_timeout():
	if abs(rotation.z) > PI / 2 - 0.1:
		if flipped:
			flipped = false
			apply_central_impulse(Vector3.UP * 128)
			rotation.z = 0
		else:
			flipped = true
	check_on_plane()


func check_on_plane():
	if global_transform.origin.y < 0:
		global_transform.origin = initpos
