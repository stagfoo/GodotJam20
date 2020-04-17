extends TextureRect

var egg_loc = -31 
var chick_loc = -178.73
var chicken_loc = -106.334
var maxDist = -178.73
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _physics_process(delta):
	if(get_node("coins").text != str(PlayerVars.points)):
		get_node("coinSound").play()
		pass
	if(get_node("rainbow").text != str(PlayerVars.rainbow_points)):
		get_node("rainbowSound").play()
		pass
	
	get_node("coins").text = str(PlayerVars.points)
	get_node("rainbow").text = str(PlayerVars.rainbow_points)
	if(PlayerVars.rainbow_points == 5):
		get_node("you-win").visible = true
	if(PlayerVars.player_state == "EGG"):
		get_node("pointer").position.x = egg_loc
	if(PlayerVars.player_state == "CHICK"):
		var cutup = PlayerVars.lifecycle / 20
		if(cutup < 5):
			get_node("pointer").position.x = chick_loc
		if(cutup == 5):
			get_node("pointer").position.x = -156
		if(cutup == 10):
			get_node("pointer").position.x = -136			
		if(cutup == 15):
			get_node("pointer").position.x = -116
			
	if(PlayerVars.player_state == "CHICKEN"):
		if(PlayerVars.lifecycle < 1):
			get_node("pointer").position.x = chicken_loc
		if(PlayerVars.lifecycle == 2):
			get_node("pointer").position.x = -81
		if(PlayerVars.lifecycle == 3):
			get_node("pointer").position.x = -71
		if(PlayerVars.lifecycle == 4):
			get_node("pointer").position.x = -54
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
