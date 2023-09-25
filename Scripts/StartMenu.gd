extends Node2D

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_PlayButton_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")

func _on_SettingsButton_pressed():
	get_tree().change_scene("res://Scenes/SettingsMenu.tscn")
