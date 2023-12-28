extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta * 10)

	move_and_slide()
	set_animation()

func set_animation():
	$Smoothing2D/AnimatedSprite2D.play()
	if velocity.x != 0:
		$Smoothing2D/AnimatedSprite2D.flip_h = velocity.x < 0
	if is_on_floor():
		if velocity.x != 0:
			$Smoothing2D/AnimatedSprite2D.animation = "run"
			$Smoothing2D/AnimatedSprite2D.flip_v = false
		else: $Smoothing2D/AnimatedSprite2D.animation = "idle"
	elif velocity.y < 0:
		$Smoothing2D/AnimatedSprite2D.animation = "jump"
	else: 
		$Smoothing2D/AnimatedSprite2D.animation = "fall" 
