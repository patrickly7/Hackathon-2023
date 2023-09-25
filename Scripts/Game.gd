extends Node2D

func _on_PauseButton_pressed():
	get_tree().change_scene("res://Scenes/PauseMenu.tscn")

func _on_GuidebookButton_pressed():
	get_tree().change_scene("res://Scenes/Guidebook.tscn")
