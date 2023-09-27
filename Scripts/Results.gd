extends Node2D

var rankingMusic = "res://Sound/Effects/Rank_S.mp3"

func _ready():
	updateResultsDisplay()
	
	yield(get_tree().create_timer(1.0), "timeout")
	$ResultsDisplay/TimeRemaining.show()
	$BackgroundSFX.stream = load("res://Sound/Effects/Results_1.mp3")
	$BackgroundSFX.play()
	
	yield(get_tree().create_timer(1.0), "timeout")
	$ResultsDisplay/SuccessfulCards.show()
	$BackgroundSFX.stream = load("res://Sound/Effects/Results_2.mp3")
	$BackgroundSFX.play()
	
	yield(get_tree().create_timer(1.0), "timeout")
	$ResultsDisplay/GuidebookUses.show()
	$BackgroundSFX.stream = load("res://Sound/Effects/Results_3.mp3")
	$BackgroundSFX.play()
	
	yield(get_tree().create_timer(1.0), "timeout")
	$Ranking.show()
	$BackgroundSFX.stream = load(rankingMusic)
	$BackgroundSFX.play()
	
	yield(get_tree().create_timer(1.0), "timeout")
	$PlayAgainButton.show()
	$StartMenuButton.show()
	$FlavorText.show()

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
		$FlavorText/Label.text = "Amazing!\nWithout the guide, too!"
		$Ranking.texture = load("res://Images/UI/S-Rank.png")
		rankingMusic = "res://Sound/Effects/Rank_S.mp3"
		return
	
	# A Rank
	if (Global.cardsSuccessfullyProcessed >= 20 && Global.timeRemaining > 0):
		$FlavorText/Label.text = "Great work!\nYou know your stuff!"
		$Ranking.texture = load("res://Images/UI/A-Rank.png")
		rankingMusic = "res://Sound/Effects/Rank_A.mp3"
		return
	
	# B Rank
	if (Global.cardsSuccessfullyProcessed >= 15):
		$FlavorText/Label.text = "Good job!\nYou almost got them all!"
		$Ranking.texture = load("res://Images/UI/B-Rank.png")
		rankingMusic = "res://Sound/Effects/Rank_B.mp3"
		return
	
	# C Rank
	if (Global.cardsSuccessfullyProcessed >= 10):
		$FlavorText/Label.text = "You're getting better.\nKeep it up!"
		$Ranking.texture = load("res://Images/UI/C-Rank.png")
		rankingMusic = "res://Sound/Effects/Rank_C.mp3"
		return
	
	# D Rank
	if (Global.cardsSuccessfullyProcessed >= 5):
		$FlavorText/Label.text = "Don't worry.\nWe all start somewhere."
		$Ranking.texture = load("res://Images/UI/D-Rank.png")
		rankingMusic = "res://Sound/Effects/Rank_D.mp3"
		return
	
	$FlavorText/Label.text = "Next time, read the guidebook.\nYou need to study more."
	$Ranking.texture = load("res://Images/UI/F-Rank.png")
	rankingMusic = "res://Sound/Effects/Rank_F.mp3"
