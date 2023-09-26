extends Node2D

func _on_ResumeButton_pressed():
	print('resume')
	hide()
	get_tree().paused = false

func _on_StartMenuButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/StartMenu.tscn")

func _on_SettingsButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/SettingsMenu.tscn")
