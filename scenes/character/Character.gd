extends CharacterBody3D

const SPEED: float = 3.0
const JUMP_BASE_VELOCITY: float = 6.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_jump: bool = false

var last_rotation: float = 0.0

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		is_jump = false
	
	var rotation := 0.0
	var direction_x = Input.get_axis("ui_left", "ui_right")
	velocity.x = (direction_x if direction_x else -direction_x) * SPEED
	var direction_z = Input.get_axis("ui_down", "ui_up")
	velocity.z = ((direction_z if not direction_z else -direction_z) / 2.5) * \
		SPEED
	rotation += (direction_x + direction_z) * SPEED * delta
	
	if Input.is_action_just_pressed("Jump") and not is_jump:
		is_jump = true
		velocity.y += JUMP_BASE_VELOCITY
	
	print(rotation)
	$Armature.rotate(Vector3.UP, rotation)
	print($Armature.rotation)
	
	move_and_slide()
	animation()

func animation():
	if velocity == Vector3.ZERO:
		$AnimationPlayer.play("idle")
		return
	
	if velocity.x != 0 or velocity.z != 0:
		$AnimationPlayer.play("run")
	
	if velocity.y != 0:
		#$AnimationPlayer.play("jump")
		pass
