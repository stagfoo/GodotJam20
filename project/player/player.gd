extends KinematicBody

# uses code from Jayanam
# https://www.youtube.com/watch?v=kc-zJnRvPUY

var facing_direction = Vector3(0,0,0)
var velocity = Vector3()
var gravity = -35
var camera
var character
var ground
var traction
var SPEED = 14
var ACCELERATION = 20
const DECELERATION = 10
const JUMP_HEIGHT = 15
var lifecycle = 0
var is_moving = false
var can_jump = false
var egg_m
var egg_c
var chick_m
var chick_c
var chicken_m
var chicken_c

var is_egg = true
var is_chic = false
var is_chicken = false

var chicken_threshold = 4
var chick_threshold = 100
var animationPlayer


func make_egg():
	lifecycle = 0
	egg_c.disabled = false
	egg_m.show()
	chicken_c.disabled = true
	chick_c.disabled = true
	chicken_m.hide()
	chick_m.hide()

func make_chick():
	chick_c.disabled = false
	chicken_c.disabled = true
	egg_c.disabled = true
	chick_m.show()
	chicken_m.hide()
	egg_m.hide()
	
func make_chicken():
	chicken_c.disabled = false
	egg_c.disabled = true
	chick_c.disabled = true
	chicken_m.show()
	egg_m.hide()
	chick_m.hide()

func chicken_tick():
	if(is_chicken):
		lifecycle += 1
		print(lifecycle)
	
func chick_tick():
	if(is_chic):
		lifecycle += 1
		print(lifecycle)
func _ready():
	character = get_node(".")
	
	# Egg 
	egg_m = get_node("0-m")
	egg_c = get_node("0-c")

	# Chick
	chick_m = get_node("1-m")
	chick_c = get_node("1-c")

	# Chicken
	chicken_m = get_node("2-m")
	chicken_c = get_node("2-c")
		
	traction = get_node("Traction")
	
func _physics_process(delta):
	if(is_egg):
		make_egg()
	if(is_chic):
		#egg_m.get_node("AnimationPlayer").play("hatch")
		make_chick()
		chick_m.get_node("AnimationPlayer").play("walk")
		if(lifecycle > chick_threshold):
			lifecycle = 0
			is_chic = false
			is_egg = false
			is_chicken = true
			make_chicken()
	if(is_chicken):
		animationPlayer = chicken_m.get_node("AnimationPlayer")
		chicken_m.get_node("AnimationPlayer").play("walk")
		make_chicken()
		if(lifecycle > chicken_threshold):
			lifecycle = 0			
			is_chic = false
			is_egg = true
			is_chicken = false
			can_jump = false
			make_egg()
		
	
	
	
	camera = get_node("target/Camera").get_global_transform()
	get_node("target/Camera").player = self
	
	loop_controls()
	
	#jump logic
	facing_direction.y = 0
	facing_direction = facing_direction.normalized()
	velocity.y += delta * gravity
	gravity = lerp(gravity, -35, 0.1)
	
	# horizontal velocity
	var hv = velocity
	hv.y = 0
	
	var new_pos = facing_direction * lerp(0, SPEED, 1)
	var accel = DECELERATION
	
	if facing_direction.dot(hv) > 0:
		accel = ACCELERATION
	
	hv = hv.linear_interpolate(new_pos, accel * delta)
	
	velocity.x = hv.x 
	velocity.z = hv.z
	
	
	# move charater
	if traction.is_colliding():
		velocity = move_and_slide_with_snap(velocity, traction.get_collision_normal(), Vector3(0,1,0), false, 4, 1)
		gravity = -35
	else:
		velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	#camera return
	if is_moving && !Input.is_key_pressed(KEY_SHIFT):
		var angle = atan2(hv.x, hv.z)
		var char_rot = get_rotation()
		char_rot.y = angle
		set_rotation(char_rot)
	# jump
	if is_on_floor():
		if(is_chicken || is_chic):
			can_jump = true
			gravity = -35
			SPEED = 14
			return
	else:
		if(is_chic):
			can_jump = false
			
			print('flying')
			chicken_m.get_node("AnimationPlayer").play("fly")
	if is_on_wall():
		can_jump = false
		return
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		print("Collided with: ", collision.collider.name)
	return



func loop_controls():
	if(is_egg):
		lifecycle = 0
	if(is_moving && is_chic):
		chick_tick()
	facing_direction = Vector3(0,0,0)
	is_moving = false
	if(Input.is_action_pressed("ui_up")):
		facing_direction += -camera.basis[2]
		is_moving = true
	if(Input.is_action_pressed("ui_down")):
		facing_direction += camera.basis[2]
		is_moving = true
	if(Input.is_action_pressed("ui_left")):
		facing_direction += -camera.basis[0]
		is_moving = true
	if(Input.is_action_pressed("ui_right")):
		facing_direction += camera.basis[0]
		is_moving = true
	if(Input.is_action_pressed("jump") && is_egg && is_on_floor()):
		can_jump = false
		is_chic = true
		is_egg = false
		is_chicken = false
	if(Input.is_action_pressed("jump") && can_jump):
			velocity.y = JUMP_HEIGHT
	if(Input.is_action_just_released("jump")):
		chicken_tick()

func _on_Coin_body_entered(body):
	var name = body.get_name()
	if(name == 'player'):
		PlayerVars.points += _Globals.coin_value
		return
	pass # Replace with function body.
