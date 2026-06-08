extends Node2D

@onready var load_menu = $SaveLoadMenu


func _on_new_game_pressed():
	GameManager.current_line = 0
	GameManager.is_intro = true
	get_tree().change_scene_to_file("res://scenes/Act 1.tscn")


func _on_load_game_pressed():
	load_menu.open_menu(false)


func _on_exit_button_pressed() -> void:
	get_tree().quit()
