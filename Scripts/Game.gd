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

const bends = [
	"res://Images/Discrep/Bend_SE.png",
	"res://Images/Discrep/Bend_SW.png"
]

const damage = "res://Images/Discrep/Damage_HolePunch.png"

const edgeWears = [
	"res://Images/Discrep/EdgeWear_Bottom.png",
	"res://Images/Discrep/EdgeWear_Left.png",
	"res://Images/Discrep/EdgeWear_Right.png",
	"res://Images/Discrep/EdgeWear_Top.png"
]

const miscut = "res://Images/Discrep/Miscut.png"

const scratches = [
	"res://Images/Discrep/Scratch_NW_SE.png",
	"res://Images/Discrep/Scratch_N_S.png",
	"res://Images/Discrep/Scratch_SW_NE.png"
]

const scribbles = [
	"res://Images/Discrep/Scribble_Jon.png",
	"res://Images/Discrep/Scribble_Orange.png",
	"res://Images/Discrep/Scribble_Patrick.png",
	"res://Images/Discrep/Scribble_Purple.png",
	"res://Images/Discrep/Scribble_Rose.png"
]

const smudges = [
	"res://Images/Discrep/Smudge_Dirt.png",
	"res://Images/Discrep/Smudge_Fingerprint.png"
]

var currentCorrectDiscrepancyType = "Condition"
var currentCorrectCondition = "Near Mint"

func _ready():
	rng.randomize()
	
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

func _on_GuidebookButton_pressed():
	hideControls()
	$Guidebook.show()
	Global.guidebookUses += 1

func _on_FlipCardButton_pressed():
	flipCard()

func _on_Timer_timeout():
	endGame()

func _process(delta):
	$TimerNode/TimerLabel.text = str(floor($TimerNode/Timer.time_left))
	if ($TimerNode/Timer.time_left < 179.75):
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
	determineSuccessfulProcessing()
	generateCard()
	cardsRemaining -= 1

func generateCard():
	generateCardStyling()
	generateCardImperfections()
	
func generateCardStyling():
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

func generateCardImperfections():	
	currentCorrectDiscrepancyType = "Condition"
	
	var numScratches = rng.randi_range(0, 3) # 0 - 3 scratches
	var numSmudges = rng.randi_range(0, 1) # 0 - 1 smudges
	var numWears = rng.randi_range(0, 4) # 0 - 4 wears
	var numBends = rng.randi_range(0, 2) # 0 - 2 bends
	
	var totalImperfections = numScratches + numSmudges + numWears + numBends
	if (totalImperfections <= 2):
		currentCorrectCondition = "Near Mint"
	elif (totalImperfections <= 4):
		currentCorrectCondition = "Lightly Played"
	elif (totalImperfections <= 6):
		currentCorrectCondition = "Moderately Played"
	elif (totalImperfections <= 8):
		currentCorrectCondition = "Heavily Played"
	else:
		currentCorrectCondition = "Damaged"
	
	### Imperfections ###
	match numSmudges:
		1:
			$Node2D/CurrentCardFront/SmudgeFingerprint.show()
		_:
			$Node2D/CurrentCardFront/SmudgeFingerprint.hide()
	
	match numScratches:
		1:
			$Node2D/CurrentCardFront/ScratchNS.hide()
			$Node2D/CurrentCardFront/ScratchNwSe.hide()
			$Node2D/CurrentCardFront/ScratchSwNe.show()
		2:
			$Node2D/CurrentCardFront/ScratchNS.hide()
			$Node2D/CurrentCardFront/ScratchNwSe.show()
			$Node2D/CurrentCardFront/ScratchSwNe.show()
		3:
			$Node2D/CurrentCardFront/ScratchNS.show()
			$Node2D/CurrentCardFront/ScratchNwSe.show()
			$Node2D/CurrentCardFront/ScratchSwNe.show()
		_:
			$Node2D/CurrentCardFront/ScratchNS.hide()
			$Node2D/CurrentCardFront/ScratchNwSe.hide()
			$Node2D/CurrentCardFront/ScratchSwNe.hide()
	
	match numWears:
		1:
			$Node2D/CurrentCardFront/EdgeWearTop.hide()
			$Node2D/CurrentCardFront/EdgeWearBottom.hide()
			$Node2D/CurrentCardFront/EdgeWearLeft.hide()
			$Node2D/CurrentCardFront/EdgeWearRight.show()
		2:
			$Node2D/CurrentCardFront/EdgeWearTop.hide()
			$Node2D/CurrentCardFront/EdgeWearBottom.hide()
			$Node2D/CurrentCardFront/EdgeWearLeft.show()
			$Node2D/CurrentCardFront/EdgeWearRight.show()
		3:
			$Node2D/CurrentCardFront/EdgeWearTop.hide()
			$Node2D/CurrentCardFront/EdgeWearBottom.show()
			$Node2D/CurrentCardFront/EdgeWearLeft.show()
			$Node2D/CurrentCardFront/EdgeWearRight.show()
		4:
			$Node2D/CurrentCardFront/EdgeWearTop.show()
			$Node2D/CurrentCardFront/EdgeWearBottom.show()
			$Node2D/CurrentCardFront/EdgeWearLeft.show()
			$Node2D/CurrentCardFront/EdgeWearRight.show()
		_:
			$Node2D/CurrentCardFront/EdgeWearTop.hide()
			$Node2D/CurrentCardFront/EdgeWearBottom.hide()
			$Node2D/CurrentCardFront/EdgeWearLeft.hide()
			$Node2D/CurrentCardFront/EdgeWearRight.hide()
	
	match numBends:
		1:
			$Node2D/CurrentCardFront/BendSw.hide()
			$Node2D/CurrentCardFront/BendSe.show()
		2:
			$Node2D/CurrentCardFront/BendSw.show()
			$Node2D/CurrentCardFront/BendSe.show()
		_:
			$Node2D/CurrentCardFront/BendSw.hide()
			$Node2D/CurrentCardFront/BendSe.hide()
	
	### Damaged Imperfections ###
	var damageChance = rng.randi_range(1, 10) # 1/10 chance for damage
	if (damageChance == 1):
		$Node2D/CurrentCardFront/Damage.show()
		currentCorrectCondition = "Damaged"
	else:
		$Node2D/CurrentCardFront/Damage.hide()
		
	var scribbleChance = rng.randi_range(1, 10) # 1/10 chance for scribbles
	if (scribbleChance == 1):
		var randomScribbleIndex = rng.randi_range(0, len(scribbles) - 1)
		$Node2D/CurrentCardFront/Scribble.texture = load(scribbles[randomScribbleIndex])
		
		$Node2D/CurrentCardFront/Scribble.show()
		currentCorrectCondition = "Damaged"
	else:
		$Node2D/CurrentCardFront/Scribble.hide()
	
	### Defect ###
	var miscutChance = rng.randi_range(1, 10) # 1/10 chance for miscut
	if (miscutChance == 1):
		$Node2D/CurrentCardBack.texture = load(miscut)
		currentCorrectDiscrepancyType = "Defect"
	else:
		$Node2D/CurrentCardBack.texture = load(cardBack)
		
	print(currentCorrectDiscrepancyType, currentCorrectCondition)

func endGame():
	var time = floor($TimerNode/Timer.time_left)
	if (time >= 180):
		Global.timeRemaining = 0
	else:
		Global.timeRemaining = time
		
	$TimerNode/Timer.stop()
	Global.cardsRemaining = cardsRemaining
	
	$TimerNode/Timer.queue_free()
	get_tree().change_scene("res://Scenes/Results.tscn")
	
func flipCard():
	if ($Node2D/CurrentCardFront.visible):
		$Node2D/CurrentCardBack.show()
		$Node2D/CurrentCardFront.hide()
	else:
		$Node2D/CurrentCardFront.show()
		$Node2D/CurrentCardBack.hide()
		
func determineSuccessfulProcessing():
	var currDiscrepancyTypeId = $ProcessCardActions/DiscrepancySelect.get_selected_id()
	var currDiscrepancyType = $ProcessCardActions/DiscrepancySelect.get_item_text(currDiscrepancyTypeId)
	
	# Do Nothing if it's not correct
	if (currDiscrepancyType != currentCorrectDiscrepancyType):
		return
	
	if (currDiscrepancyType == "Condition"):
		var currConditionTypeId = $ProcessCardActions/ConditionSelect.get_selected_id()
		var currCondition = $ProcessCardActions/ConditionSelect.get_item_text(currConditionTypeId)
		
		if (currCondition != currentCorrectCondition):
			return
	
	Global.cardsSuccessfullyProcessed += 1

func _on_PauseButton_pressed():
	get_tree().paused = true
	$PauseMenu.show()
	$PauseButton.hide()
	$ProcessCardActions.hide()

func _on_PauseMenu_hide():
	$PauseButton.show()
	$ProcessCardActions.show()
