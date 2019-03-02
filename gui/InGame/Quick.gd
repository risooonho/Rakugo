extends HBoxContainer

onready var Screens : = get_node("../../Screens")
var save_error_msg : String = "[color=red]Error saving Game[/color]"
var load_error_msg : String = "[color=red]Error loading Game[/color]"

func _ready() -> void:
	Rakugo.connect("exec_statement", self, "_on_statement")
	$Auto.connect("pressed", self, "on_auto")
	
	$Skip.connect("pressed", self, "on_skip")
	$Skip.disabled = true

	Rakugo.skip_timer.connect("stop_loop", self, "on_stop_loop")
	Rakugo.auto_timer.connect("stop_loop", self, "on_stop_loop")

	$History.connect("pressed", Screens, "history_menu")
	$History.disabled = true
	
	$QSave.connect("pressed", self, "_on_qsave")
	$QLoad.connect("pressed",self, "_on_qload")
	
	$Save.connect("pressed", self, "full_save")
	$Load.connect("pressed", Screens, "load_menu")
	$Quests.connect("pressed", Screens, "_on_Quests_pressed")
	$Quit.connect("pressed", Screens, "_on_Quit_pressed")
	$Options.connect("pressed", Screens, "_on_Options_pressed")

func _on_qsave() -> void:
	if Rakugo.savefile():
		$InfoAnim.play("Saved")
	
	else:
		$InfoAnim/Panel/Label.bbcode_text = save_error_msg
		$InfoAnim.play("GeneralNotif")

func _on_qload() -> void:
	if Rakugo.loadfile():
		$InfoAnim.play("Loaded")
		Rakugo.story_step()
	
	else:
		$InfoAnim/Panel/Label.bbcode_text = load_error_msg
		$InfoAnim.play("GeneralNotif")

func _on_statement(type : int, parameters : Dictionary) -> void:
	$Skip.disabled = !Rakugo.can_skip()
	$Auto.disabled = !Rakugo.can_auto()
	$History.disabled = Rakugo.history_id == 0
	$QLoad.disabled = !Rakugo.can_qload()

func on_auto() -> void:
	$Skip.pressed = false
	if not Rakugo.auto_timer.run():
		on_stop_loop()
		return
	
	$InfoAnim.play("Auto")

func on_stop_loop() -> void:
	$Auto.pressed = false
	$Skip.pressed = false
	$InfoAnim.stop()
	$InfoAnim/Panel.hide()

func on_skip() -> void:
	$Auto.pressed = false
	if not Rakugo.skip_timer.run():
		on_stop_loop()
		return

	$InfoAnim.play("Skip")

func full_save() -> void:
	var screenshot = Screens.get_screenshot()
	Screens.save_menu(screenshot)
	
func _hide_on_input(event):
	if event.is_action_pressed("ui_select"):
		$Hide.pressed = !$Hide.pressed
		$Hide.emit_signal("toggled", $Hide.pressed)

func _input(event : InputEvent) -> void:
	if Rakugo.can_alphanumeric:
		_hide_on_input(event)
	
	if event.is_action_pressed("rakugo_qsave"):
		_on_qsave()
		return
	
	if event.is_action_pressed("rakugo_qload"):
		_on_qload()
		return
