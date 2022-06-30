extends Node

const SAVE_FILE = "user://save_file.save"

var game_data = {
	
	"ship_position": Vector2(332,182)
	
}


func _ready():
	pass
	
func save_data():
	var file = File.new()
	var error = file.open(SAVE_FILE, File.WRITE)
	if error == OK:
		file.store_var(game_data)
		file.close()
	
func load_data():
	var file = File.new()
	if file.file_exists(SAVE_FILE):
		var error = file.open(SAVE_FILE, File.READ)
		if error == OK:
			game_data = file.get_var()
			file.close()
