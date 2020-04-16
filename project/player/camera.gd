extends Camera

# uses code from Jayanam
# https://www.youtube.com/watch?v=kc-zJnRvPUY

var distance = 10
var height = 4

var player
var lockon

var lspeed = 0.2

func _ready():
	player = get_parent().get_parent()
	
	set_as_toplevel(true)

func _physics_process(delta):
	var target = get_parent().get_global_transform().origin
	var pos = get_global_transform().origin
	var up = Vector3(0,1,0)
	
	var offset = pos - target
	
	offset = offset.normalized()*distance
	offset.y = height
	
	pos = pos.linear_interpolate(target + offset, lspeed) 
	
	look_at_from_position(pos, target, up)
