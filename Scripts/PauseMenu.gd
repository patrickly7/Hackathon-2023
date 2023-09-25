extends Node2D

func _on_ResumeButton_pressed():
	hide()
	get_tree().paused = false

func _on_StartMenuButton_pressed():
	get_tree().change_scene("res://Scenes/StartMenu.tscn")

func _on_SettingsButton_pressed():
	get_tree().change_scene("res://Scenes/SettingsMenu.tscn")
