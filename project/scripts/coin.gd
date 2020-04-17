extends RigidBody

func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(5)
	pass

func _physics_process(delta):
	get_node("AnimationPlayer").play("rotate")
	pass

func _on_Coin_body_shape_entered(body_id, body, body_shape, local_shape):
	var name = body.get_name()
	if(name == 'player'):
		PlayerVars.points += _Globals.coin_value
		self.queue_free()
	pass # Replace with function body.
