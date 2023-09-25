extends Node2D

var cardFront = "res://Images/Card/CardFront.png"
var cardBack = "res://Images/Card/CardBack.png"

func _ready():
	# Give time for GET READY text
	yield(get_tree().create_timer(2.0), "timeout")
	
	# Start Timer and Show START text
	$TimerNode.show()
	$TimerNode/Timer.start()
	$GetReadyText.hide()
	$StartText.show()

func _on_PauseButton_pressed():
	get_tree().paused = true
	$PauseMenu.show()

func _on_GuidebookButton_pressed():
	$Guidebook.show()

func _on_FlipCardButton_pressed():
#	if ($CurrentCardFront.texture == load(cardFront)):
#		$CurrentCard.texture = load(cardBack)
#	else:
#		$CurrentCard.texture = load(cardFront)
	if ($Node2D/CurrentCardFront.visible):
		$Node2D/CurrentCardBack.show()
		$Node2D/CurrentCardFront.hide()
	else:
		$Node2D/CurrentCardFront.show()
		$Node2D/CurrentCardBack.hide()

func _on_Timer_timeout():
	get_tree().change_scene("res://Scenes/Results.tscn")
	$TimerNode/Timer.queue_free()

func _process(delta):
	$TimerNode/TimerLabel.text = str(floor($TimerNode/Timer.time_left))
	if ($TimerNode/Timer.time_left < 179):
		$StartText.hide()
