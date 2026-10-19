extends CanvasLayer

signal resume_pressed
signal settings_pressed
signal main_menu_pressed


func _on_resume_button_pressed() -> void:
	resume_pressed.emit()


func _on_settings_button_pressed() -> void:
	settings_pressed.emit()


func _on_main_menu_button_pressed() -> void:
	main_menu_pressed.emit()
