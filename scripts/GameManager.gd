extends Node

var current_line = 0
var is_intro = true
var save_folder = "user://saves/"

func get_save_path(slot: int):
	return save_folder + "save_" + str(slot) + ".json"

func save_game(slot: int):
	if not DirAccess.dir_exists_absolute(save_folder):
		DirAccess.make_dir_recursive_absolute(save_folder)
		
	var path = get_save_path(slot)
	var data = {
		"current_line": current_line,
		"is_intro": is_intro,
		"date": Time.get_datetime_string_from_system()
	}
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		print("GameManager: Saved to slot ", slot)

func load_game(slot: int):
	var path = get_save_path(slot)
	if not FileAccess.file_exists(path):
		return false

	var file = FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()

	if data:
		current_line = data["current_line"]
		is_intro = data["is_intro"]
		print("GameManager: Loaded slot ", slot)
		return true
	return false

func delete_save(slot: int):
	var path = get_save_path(slot)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
