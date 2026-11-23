extends Control

signal start_pressed
signal exit_pressed


func _ready() -> void:
	$Center/Content/StartButton.pressed.connect(start_pressed.emit)
	$Center/Content/ExitButton.pressed.connect(exit_pressed.emit)
	$Center/Content/StartButton.grab_focus()
