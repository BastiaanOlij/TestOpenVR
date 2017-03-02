extends OpenVRHMD

func _ready():
	# size our viewports
	var size = get_recommended_rendertarget_size()
	get_parent().get_node("left_eye_viewport").set_rect(Rect2(0.0, 0.0, size.x, size.y))
	get_parent().get_node("right_eye_viewport").set_rect(Rect2(0.0, 0.0, size.x, size.y))
	
	# we show our left eye as a preview.
	# we're goint to make a 3rd camera optional so we can overlay a green screen
	# also note that we should find a way to get our fps at a fraction of what we're rendering
	# to the hmd
	var winsize = OS.get_window_size()
	var scale = winsize.x / size.x
	get_parent().get_node("ViewportSprite_left").set_offset(Vector2(0.0, (winsize.y - (size.y * scale)) / 2.0))
	get_parent().get_node("ViewportSprite_left").set_scale(Vector2(scale, scale))
	
	# note, process is always turned on for this, don't turn it off!
	
func _process(delta):
	# set our left and right eye camera positions
	# note that our IPD may change so the eye positions we're getting
	# aren't necesairily static

	var leftcam = get_parent().get_node("left_eye_viewport/left_eye_camera")
	var rightcam = get_parent().get_node("right_eye_viewport/right_eye_camera")
	var near = 0.05
	var far = 1000.0
	
	if (leftcam):
		leftcam.set_global_transform(get_lefteye_global_transform())
		
		var frustum = get_lefteye_frustum()
		# we are abusing size to store our right and bottom values
		leftcam.set_frustum(frustum.pos.x, frustum.size.x,frustum.pos.y, frustum.size.y,near,far)
		

	if (rightcam):
		rightcam.set_global_transform(get_righteye_global_transform())
		
		var frustum = get_righteye_frustum()
		# we are abusing size to store our right and bottom values
		rightcam.set_frustum(frustum.pos.x, frustum.size.x,frustum.pos.y, frustum.size.y,near,far)
