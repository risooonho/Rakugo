## This is Ren'GD tutorial script ##

## version: 0.7 ##
## License MIT ##

extends "res://scripts/RenGD/ren_short.gd"

var tscn_path

func _ready():
	tscn_path = get_parent().tscn_path
	dialog("basic", tscn_path, get_path(), 'basic')


func basic():
	say("Test", "RESULT_SUCCESS!")
	g("print(get_parent().get_name())")
	# g("print(version)") # don't work yet
	
	do_dialog()

	