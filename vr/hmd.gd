tool
extends SpatialTracker

func _ready():
	# note, if we don't want something to run while editing:
	# gettree().is_editor_hint()
	
	# size our viewports
	var size = get_recommended_rendertarget_size()
	get_parent().get_node("left_eye_viewport").set_rect(Rect2(0.0, 0.0, size.x, size.y))
	get_parent().get_node("right_eye_viewport").set_rect(Rect2(0.0, 0.0, size.x, size.y))
	
	# note, process is always turned on for this, don't turn it off!
	
func _process(delta):
	# set our left and right eye camera positions
	# note that our IPD may change so the eye positions we're getting
	# aren't necesairily static

	var leftcam = get_parent().get_node("left_eye_viewport/left_eye_camera")
	var rightcam = get_parent().get_node("right_eye_viewport/right_eye_camera")
	
	if (leftcam):
		leftcam.set_global_transform(get_lefteye_global_transform())

	if (rightcam):
		rightcam.set_global_transform(get_righteye_global_transform())
	
	# now set our projection matrices, again these probably never change
	# but could alter based on IPD being updated on the headset
