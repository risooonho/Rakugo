extends CollapsedList

func _ready() -> void:
	connect("visibility_changed", self, "_on_visibility_changed")
	settings.connect("window_size_changed", self, "_on_window_size_changed")
	## taken from https://freegamedev.net/wiki/Screen_Resolutions
	options_list = [
		Vector2(640, 480),
		Vector2(800, 480),
		Vector2(1024, 600),
		Vector2(1024, 768),
		Vector2(1200, 900),
		Vector2(1280, 720),
		Vector2(1280, 1024),
		Vector2(1366, 768),
		Vector2(1440, 900),
		Vector2(1680, 1050),
		Vector2(1600, 1200),
		Vector2(1920, 1080),
		Vector2(2560, 1440),
		Vector2(2560, 1600)
	]

func _on_visibility_changed() -> void:
	update_label(OS.window_size, false)
	
func _on_window_size_changed(prev, now):
	update_label(now, false)

func update_label(size : Vector2 = options_list[current_choice_id], apply : bool = true) -> void:
	label.text = str(size.x) + "x" + str(size.y)
	
	if not (size in options_list):
		options_list.append(size)
	
	if not apply:
		return
	
	settings.temp_window_size = size
	
	if settings.temp_window_size != OS.get_screen_size():
		if settings.temp_window_type_id == 1: # if fullscreen
			settings.temp_window_type_id = 2 # Maximized
			
	settings.apply()