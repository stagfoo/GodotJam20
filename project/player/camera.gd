extends Camera

# uses code from Jayanam
# https://www.youtube.com/watch?v=kc-zJnRvPUY

var distance = 8
var height = 3

var player
var lockon

var lspeed = 0.2

func _ready():
	player = get_parent().get_parent()
	lockon = player.get_node("LockOn")
	
	set_as_toplevel(true)

func _physics_process(delta):
	if Input.is_key_pressed(KEY_SHIFT):
		var new_transform = lockon.global_transform
		
		var camray = player.get_node("CamRay")
		if camray.is_colliding():
			new_transform[3].x = camray.get_collision_point().x
			new_transform[3].z = camray.get_collision_point().z
		
		global_transform[0] = global_transform[0].linear_interpolate(new_transform[0], lspeed)
		global_transform[1] = global_transform[1].linear_interpolate(new_transform[1], lspeed)
		global_transform[2] = global_transform[2].linear_interpolate(new_transform[2], lspeed)
		global_transform[3] = global_transform[3].linear_interpolate(new_transform[3], lspeed)
		
		return
	
	
	var target = get_parent().get_global_transform().origin
	var pos = get_global_transform().origin
	var up = Vector3(0,1,0)
	
	var offset = pos - target
	
	offset = offset.normalized()*distance
	offset.y = height
	
	pos = pos.linear_interpolate(target + offset, lspeed) 
	
	look_at_from_position(pos, target, up)
