extends VehicleBody

const max_torque = 400
const max_rpm = 2000
const max_brake_force = 10

onready var back_wheels = [get_node("back_left"), get_node("back_right")]
onready var audio_player = $AudioStreamPlayer3D
onready var fps_label = $CanvasLayer/Control/fps
onready var speed_label = $CanvasLayer/Control/speed
onready var initpos = global_transform.origin
onready var prev_pos = initpos

var cam_first = true

func _physics_process(delta):
	steering = lerp(steering, Input.get_axis("right", "left") * 0.4, 5 * delta)
	var acceleration = Input.get_axis("backward", "forward")
	if acceleration != 0:
		for wheel in back_wheels:
			wheel.engine_force = acceleration * max_torque * (1 - wheel.get_rpm() / max_rpm)
	else:
		for wheel in back_wheels: wheel.engine_force = 0

	audio_player.unit_db = 8.69 * log(abs(back_wheels[0].get_rpm() + 1) / max_rpm)
	
	if Input.is_action_pressed("space"):
		brake = lerp(brake, max_brake_force, 8 * delta)
	elif brake != 0:
		brake = 0
	speed_label.text = str(floor((global_transform.origin - prev_pos).length() * 3.6 / delta)) + " km/hr"
	prev_pos = global_transform.origin
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func _input(event):
	if event.is_action_pressed("flip"):
		apply_central_impulse(Vector3.UP * 128)
		rotation.z = 0
	elif event.is_action_pressed("respawn"):
		global_transform.origin = initpos
