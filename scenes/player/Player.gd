extends CharacterBody3D

const SPEED: float = 3.0
const JUMP_BASE_VELOCITY: float = 6.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_jump: bool = false
var jump_in_wall: bool = false
var is_hang_animation: bool = false

var is_push: bool = false
var push_last_direction: Vector3 = Vector3.ZERO

func _physics_process(delta):
	is_push = false
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		is_jump = false
		jump_in_wall = false
	
	if Input.is_action_just_pressed("ui_accept") and not is_jump:
		is_jump = true
		velocity.y += JUMP_BASE_VELOCITY
		if is_on_wall() and (not $RayCastRight.is_colliding() or \
			not $RayCastLeft.is_colliding()):
			jump_in_wall = true
	
	var direction_x = Input.get_axis("ui_left", "ui_right")
	velocity.x = (direction_x if direction_x else -direction_x) * SPEED
	var direction_z = Input.get_axis("ui_down", "ui_up")
	velocity.z = ((direction_z if not direction_z else -direction_z) / 2.5) * \
		SPEED
	
	var bodies = $AreaDetectObjects.get_overlapping_bodies()
	for body in bodies:
		if body.name.find("Box") > -1:
			if push_last_direction == velocity:
				velocity.x /= 2
				velocity.z /= 2
				var move = Vector3(velocity.x, \
					0, velocity.z) * delta
					
				var box: StaticBody3D = body
				box.move_and_collide(move)
			
			is_push = true
			push_last_direction = velocity
			break
	
	if is_on_wall() and not jump_in_wall and not is_push:
		if ($Animation.flip_h and not $RayCastLeft.is_colliding()) or \
			(not $Animation.flip_h and not $RayCastRight.is_colliding()):
			is_hang_animation = true
			is_jump = false
			velocity.y = 0
	else:
		is_hang_animation = false
	
	move_and_slide()
	animation()

func animation():
	if velocity == Vector3.ZERO:
		var type = "Idle"
		
		if is_hang_animation:
			type = "Hang"
		
		$Animation.play(type)
		return
	
	if velocity.x != 0 or velocity.z != 0:
		$Animation.flip_h = true if velocity.x < 0 else false
		if velocity.y == 0:
			$Animation.play("Run")
	else: $Animation.flip_h = $Animation.flip_h
	
	if velocity.y != 0:
		var type = "Jump" if velocity.y > 0 else "Fall"
		
		$Animation.play(type)
