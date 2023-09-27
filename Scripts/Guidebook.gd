extends Node2D

func _on_CloseButton_pressed():
	$BackgroundSFX.play()
	hide()

func _on_TabContainer_tab_changed(tab):
	$BackgroundSFX.play()
