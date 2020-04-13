extends RigidBody

func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(5)
	pass

func _physics_process(delta):
	get_node("AnimationPlayer").play("rotate")
	pass
func _on_Coin_body_entered(body):
	var name = body.get_name()
	if(name == 'player'):
		self.queue_free()
		return
	pass # Replace with function body.
