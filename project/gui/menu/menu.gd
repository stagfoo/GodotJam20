extends ItemList

onready var START_BUTTON = get_node("Start Game")
onready var END_BUTTON =  get_node("End Game")

func _ready():
	pass

func _process(delta):
	pass
func _on_Button_pressed():
	if(START_BUTTON.pressed):
		_Globals.goto_scene("res://scenes/main.tscn")
		return
	if(END_BUTTON.pressed):
		get_tree().quit()
		return
	pass
