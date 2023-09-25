extends Node2D

func _on_PlayAgainButton_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")

func _on_StartMenuButton_pressed():
	get_tree().change_scene("res://Scenes/StartMenu.tscn")
