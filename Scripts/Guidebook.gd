extends Node2D

func _on_CloseButton_pressed():
	$BackgroundSFX.play()
	hide()

func _on_TabContainer_tab_changed(tab):
	$BackgroundSFX.play()

func _on_LeftArrow_pressed():
	if ($TabContainer.current_tab == 0):
		return
		
	$TabContainer.current_tab -= 1
	$BackgroundSFX.play()

func _on_RightArrow_pressed():
	if ($TabContainer.current_tab == $TabContainer.get_tab_count() - 1):
		return
		
	$TabContainer.current_tab += 1
	$BackgroundSFX.play()
