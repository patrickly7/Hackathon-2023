extends Node2D

func _ready():
	updateResultsDisplay()
	
	yield(get_tree().create_timer(1.0), "timeout")
	$ResultsDisplay/TimeRemaining.show()
	yield(get_tree().create_timer(1.0), "timeout")
	$ResultsDisplay/SuccessfulCards.show()
	yield(get_tree().create_timer(1.0), "timeout")
	$ResultsDisplay/GuidebookUses.show()
	yield(get_tree().create_timer(1.0), "timeout")
	$Ranking.show()
	
	yield(get_tree().create_timer(1.0), "timeout")
	$PlayAgainButton.show()
	$StartMenuButton.show()

func _on_PlayAgainButton_pressed():
	resetGlobalVariables()
	get_tree().change_scene("res://Scenes/Game.tscn")

func _on_StartMenuButton_pressed():
	get_tree().change_scene("res://Scenes/StartMenu.tscn")

func resetGlobalVariables():
	Global.cardsRemaining = 0
	Global.cardsSuccessfullyProcessed = 0
	Global.timeRemaining = 0
	Global.guidebookUses = 0

func updateResultsDisplay():
	$ResultsDisplay/TimeRemaining.text = "Time Remaining: " + str(Global.timeRemaining) + " seconds"
	$ResultsDisplay/SuccessfulCards.text = "Cards Successfully Processed: " + str(Global.cardsSuccessfullyProcessed) + " / 20"
	$ResultsDisplay/GuidebookUses.text = "Guidebook Uses: " + str(Global.guidebookUses)
	
	calculateRank()
	
func calculateRank():
	# S Rank
	if (Global.guidebookUses <= 0 && Global.cardsSuccessfullyProcessed >= 20 && Global.timeRemaining > 0):
		$Ranking.texture = load("res://Images/UI/S-Rank.png")
		return
	
	# A Rank
	if (Global.cardsSuccessfullyProcessed >= 20 && Global.timeRemaining > 0):
		$Ranking.texture = load("res://Images/UI/A-Rank.png")
		return
	
	# B Rank
	if (Global.cardsSuccessfullyProcessed >= 15):
		$Ranking.texture = load("res://Images/UI/B-Rank.png")
		return
	
	# C Rank
	if (Global.cardsSuccessfullyProcessed >= 10):
		$Ranking.texture = load("res://Images/UI/C-Rank.png")
		return
	
	# D Rank
	if (Global.cardsSuccessfullyProcessed >= 5):
		$Ranking.texture = load("res://Images/UI/D-Rank.png")
		return
	
	$Ranking.texture = load("res://Images/UI/F-Rank.png")
