extends CanvasLayer

signal resume_pressed
signal restart_pressed
signal main_menu_pressed


func _ready() -> void:
	$Root/Center/Panel/Content/ResumeButton.grab_focus()
	$Root/Center/Panel/Content/ResumeButton.pressed.connect(resume_pressed.emit)
	$Root/Center/Panel/Content/RestartButton.pressed.connect(restart_pressed.emit)
	$Root/Center/Panel/Content/MainMenuButton.pressed.connect(main_menu_pressed.emit)
