extends Spatial

export var FIRERATE = 10

onready var timer = $Timer
onready var raycast = $RayCast

func _ready():
	timer.wait_time = FIRERATE / 60

func _input(event):
	if event.is_action("fire"):
		if timer.is_stopped():
			timer.start()
		else:
			timer.stop()

func _on_Timer_timeout():
	var obj = raycast.get_collider()
	pass
