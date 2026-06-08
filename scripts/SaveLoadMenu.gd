extends CanvasLayer

@onready var confirm_pop = $ConfirmationPop
@onready var delete_pop = $DeletePop
@onready var title_label = get_node_or_null("MenuTitle")

var selected_slot = -1
var is_saving = true

func _ready():
	hide()

func open_menu(saving_mode: bool):
	if self.visible:
		return

	is_saving = saving_mode
	if title_label:
		title_label.text = "SAVE GAME" if is_saving else "LOAD GAME"
	
	update_slot_labels()
	show()

func update_slot_labels():
	for i in range(1, 5):
		var slot_node_name = "VBoxContainer/Slot" + str(i)
		if has_node(slot_node_name):
			var btn = get_node(slot_node_name)
		
			if FileAccess.file_exists(GameManager.get_save_path(i)):
				btn.text = "Slot " + str(i) + " (Saved Data)"
			else:
				btn.text = "Slot " + str(i) + " (Empty)"

func _on_slot_pressed(slot_num: int):
	selected_slot = slot_num
	var path = GameManager.get_save_path(slot_num)
	if is_saving:
		if FileAccess.file_exists(path):
			confirm_pop.dialog_text = "Overwrite Save Slot " + str(slot_num) + "?"
			confirm_pop.popup_centered()
		else:
			execute_save()
	else:
		if FileAccess.file_exists(path):
			execute_load()
		else:
			print("Cannot load an empty slot!")

func _on_confirmation_pop_confirmed():
	if is_saving:
		execute_save()

func execute_save():
	GameManager.save_game(selected_slot)
	update_slot_labels()

func execute_load():
	if GameManager.load_game(selected_slot):
		var current_scene = get_tree().current_scene
		
		if current_scene.has_method("update_dialogue"):
			current_scene.update_dialogue()
			hide()
		else:
			get_tree().change_scene_to_file("res://scenes/Act 1.tscn")
	else:
		print("Failed to load data.")

func _on_back_button_pressed():
	hide()
	
func _on_delete_pressed(slot_num: int):
	selected_slot = slot_num
	delete_pop.dialog_text = "Delete save in Slot " + str(slot_num) + "?"
	delete_pop.popup_centered()

func _on_delete_pop_confirmed():
	GameManager.delete_save(selected_slot)
	update_slot_labels()
