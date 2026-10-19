extends Control

signal back_pressed

@onready var speed_slider: HSlider = %SpeedSlider
@onready var speed_label: Label = %SpeedValueLabel


func _ready() -> void:
	speed_slider.min_value = 2
	speed_slider.max_value = 15
	speed_slider.step = 0.5
	speed_slider.value = Settings.speed
	speed_label.text = str(Settings.speed)
	speed_slider.value_changed.connect(_on_speed_slider_value_changed)
	%BackButton.pressed.connect(_on_back_button_pressed)


func _on_speed_slider_value_changed(value: float) -> void:
	Settings.speed = value
	speed_label.text = str(value)


func _on_back_button_pressed() -> void:
	back_pressed.emit()
