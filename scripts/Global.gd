extends Node

var ult_charge = 0					# Current ultimate meter charge value
var ult_max = 100					# Ultimate meter maximum charge value
var _ult_damage_to_charge = .1		# What damage dealt is multiplied by before being added to ultimate charge
var game							# Reference to Game node (self-registers onready)
var tower_hp = 100					# Current tower health value
var tower_hp_max = 100				# Tower maximum health value

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func increase_ult_charge(num):
	# Increase the ultimate charge by raw damage multiplied by dampener value
	ult_charge += (num * _ult_damage_to_charge)
	
	# Cap ultimate charge at max value if it exceeds it
	if (ult_charge >= ult_max):
		ult_charge = ult_max
		# If at max value, change meter color
		game.get_node("TowerDefenseHUD/UltimateMeter").set("modulate",Color(0.0,0.0,1.0))
	else:
		# If not at max value, ensure meter color is set to default
		game.get_node("TowerDefenseHUD/UltimateMeter").set("modulate",Color(1.0,1.0,1.0))
	# Increase ultimate meter fill bar to match charge value
	game.get_node("TowerDefenseHUD/UltimateMeter/Fill").set_value(ult_charge)

func decrease_ult_charge(num):
	# Decrease the ultimate charge by value specified
	ult_charge -= num
	# Ensure meter color is set to default
	game.get_node("TowerDefenseHUD/UltimateMeter").set("modulate",Color(1.0,1.0,1.0))
	# Increase ultimate meter fill bar to match charge value
	game.get_node("TowerDefenseHUD/UltimateMeter/Fill").set_value(ult_charge)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass