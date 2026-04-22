extends LinkButton

@export var scene_to_load: String

func _on_Select_New_Game_pressed():
	get_tree().change_scene_to_file(str("res://scenes/" + scene_to_load + ".tscn"))
