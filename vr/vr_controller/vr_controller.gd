extends OpenVRController

func _ready():
	set_process(true)

func _process(delta):
	var rotation = get_node("Trigger_origin").get_rotation_deg()
	rotation.x = get_trigger() * -30.0
	get_node("Trigger_origin").set_rotation_deg(rotation)
	