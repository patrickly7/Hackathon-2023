extends Node2D

var cardFront = "res://Images/Card/CardFront.png"
var cardBack = "res://Images/Card/CardBack.png"

var rng = RandomNumberGenerator.new()

var cardsRemaining = 20

const cardNames = [
	"res://Images/Text/BlurbText.png",
	"res://Images/Text/MidText.png",
	"res://Images/Text/LongText.png"
]

const energies = [
	"res://Images/Energy/Paper.png",
	"res://Images/Energy/Rock.png",
	"res://Images/Energy/Scissors.png"
]

const descriptionTexts = [
	"res://Images/Text/ShortBlurbText.png",
	"res://Images/Text/ShortLongText.png",
	"res://Images/Text/ShortMidText.png",
	"res://Images/Text/TallBlurbText.png",
	"res://Images/Text/TallLongText.png",
	"res://Images/Text/TallMidText.png"
]

const cardArts = [
	"res://Images/CardArt/Bee.png",
	"res://Images/CardArt/Flower.png",
	"res://Images/CardArt/Glass.png",
	"res://Images/CardArt/Box.png",
	"res://Images/CardArt/Cloud.png"
]

func _ready():
	# Give time for GET READY text
	yield(get_tree().create_timer(2.0), "timeout")
	
	# Start Timer and Show START text
	$TimerNode.show()
	$TimerNode/Timer.start()
	$GetReadyText.hide()
	$StartText.show()
	$PauseButton.show()
	$CardsRemaining.show()
	$FlipCardButton.show()
	$ProcessCardActions.show()
	$GuidebookButton.show()
	
	$ProcessCardActions/DiscrepancySelect.add_item("Condition")
	$ProcessCardActions/DiscrepancySelect.add_item("Defect")
	
	$ProcessCardActions/ConditionSelect.add_item("Near Mint")
	$ProcessCardActions/ConditionSelect.add_item("Lightly Played")
	$ProcessCardActions/ConditionSelect.add_item("Moderately Played")
	$ProcessCardActions/ConditionSelect.add_item("Heavily Played")
	$ProcessCardActions/ConditionSelect.add_item("Damaged")
	
	# Generate the first card
	generateCard()
	flipCard()

func _on_PauseButton_pressed():
	get_tree().paused = true
	$PauseMenu.show()

func _on_GuidebookButton_pressed():
	hideControls()
	$Guidebook.show()

func _on_FlipCardButton_pressed():
	flipCard()

func _on_Timer_timeout():
	endGame()

func _process(delta):
	$TimerNode/TimerLabel.text = str(floor($TimerNode/Timer.time_left))
	if ($TimerNode/Timer.time_left < 179):
		$StartText.hide()
		
	# Verify if Condition Select should be disabled
	var currDiscrepancyTypeId = $ProcessCardActions/DiscrepancySelect.get_selected_id()
	var currDiscrepancyType = $ProcessCardActions/DiscrepancySelect.get_item_text(currDiscrepancyTypeId)
	
	if (currDiscrepancyType == "Condition"):
		$ProcessCardActions/ConditionSelect.disabled = false
	else:
		$ProcessCardActions/ConditionSelect.disabled = true
		
	# Update Cards Remaining
	$CardsRemaining.text = "Cards Remaining: " + str(cardsRemaining)	
	
	# Verify if there are no cards remaining
	if (cardsRemaining <= 0):
		endGame()

func _on_Guidebook_hide():
	showControls()

func hideControls():
	$GuidebookButton.hide()
	$PauseButton.hide()
	$ProcessCardActions.hide()

func showControls():
	$GuidebookButton.show()
	$PauseButton.show()
	$ProcessCardActions.show()

func _on_SubmitButton_pressed():
	generateCard()
	cardsRemaining -= 1

func generateCard():
	var randomCardNameIndex = rng.randi_range(0, 2)
	$Node2D/CurrentCardFront/CardName.texture = load(cardNames[randomCardNameIndex])
	
	var randomEnergyIndex = rng.randi_range(0, 2)
	$Node2D/CurrentCardFront/Energy.texture = load(energies[randomEnergyIndex])
	
	var randomTopBlurbIndex = rng.randi_range(0, 5)
	$Node2D/CurrentCardFront/BlurbTop.texture = load(descriptionTexts[randomTopBlurbIndex])
	
	var randomBottomBlurbIndex = rng.randi_range(0, 5)
	$Node2D/CurrentCardFront/BlurbBottom.texture = load(descriptionTexts[randomBottomBlurbIndex])
	
	var randomCardArtIndex = rng.randi_range(0, 4)
	$Node2D/CurrentCardFront/CardArt.texture = load(cardArts[randomCardArtIndex])
	
func endGame():
	$TimerNode/Timer.queue_free()
	get_tree().change_scene("res://Scenes/Results.tscn")
	
func flipCard():
	if ($Node2D/CurrentCardFront.visible):
		$Node2D/CurrentCardBack.show()
		$Node2D/CurrentCardFront.hide()
	else:
		$Node2D/CurrentCardFront.show()
		$Node2D/CurrentCardBack.hide()
