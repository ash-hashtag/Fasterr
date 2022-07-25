extends VehicleBody

const max_torque = 800
const max_rpm = 1000
const max_brake_force = 10

onready var back_wheels = [get_node("back_left"), get_node("back_right")]
onready var audio_player = $AudioStreamPlayer3D
onready var initpos = global_transform.origin

var cam_first = true

func _physics_process(delta):
	steering = lerp(steering, Input.get_axis("right", "left") * 0.4, 5 * delta)
	var acceleration = Input.get_axis("backward", "forward")
	if acceleration != 0:
		for wheel in back_wheels:
			wheel.engine_force = acceleration * max_torque * (1 - wheel.get_rpm() / max_rpm)
	else:
		for wheel in back_wheels: wheel.engine_force = 0

	audio_player.unit_db = 8.69 * log(back_wheels[0].get_rpm() * 2 / max_rpm)
	
	if Input.is_action_pressed("space"):
		brake = lerp(brake, max_brake_force, 8 * delta)
	elif brake != 0:
		brake = 0

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
