extends CanvasLayer

signal restart_pressed
signal main_menu_pressed
signal cancel_pressed

var victory: bool = false


func _ready() -> void:
	if victory:
		$Root/Center/Panel/Content/Title.text = "You won!"
		$Root/Center/Panel/Content/Description.text = "Level complete."
		$Root/Center/Panel/Content/RestartButton.text = "PLAY AGAIN"
		$Root/Center/Panel/Content/CancelButton.hide()
	else:
		$Root/Center/Panel/Content/Title.text = "Restart?"
		$Root/Center/Panel/Content/Description.text = "Reset coins and checkpoint?"
	$Root/Center/Panel/Content/RestartButton.pressed.connect(restart_pressed.emit)
	$Root/Center/Panel/Content/MainMenuButton.pressed.connect(main_menu_pressed.emit)
	$Root/Center/Panel/Content/CancelButton.pressed.connect(cancel_pressed.emit)
	$Root/Center/Panel/Content/RestartButton.grab_focus()
