extends CharacterBody2D

class_name Player

signal attack_released(charge_time)
signal attack_canceled

# Enum for elemental resources
enum Element { NONE, FIRE, WATER, EARTH, AIR }

const BASE_SPEED := 200.0
const JUMP_VELOCITY := -400.0

# Elemental resource variables
@export var elemental_resources := {
	Element.FIRE: 100.0,
	Element.WATER: 100.0,
	Element.EARTH: 100.0,
	Element.AIR: 100.0
}

# Elemental resource maximum variables
@export var elemental_resource_maxes := {
	Element.FIRE: 100.0,
	Element.WATER: 100.0,
	Element.EARTH: 100.0,
	Element.AIR: 100.0
}

var speed_modifier := 1.0
var speed : float:
	get:
		return BASE_SPEED * speed_modifier
var active_element : Element = Element.NONE
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var _charging := false # Is the player currently charging an attack?

@onready var hud : CanvasLayer = get_tree().get_first_node_in_group("hud")
@onready var attack_timer : Timer = $AttackTimer

func _ready():
	_update_hud() # Ensure HUD reflects initial resource values

func _process(delta):
	_drain_resources(delta)
	_cycle_active_element_on_input()
	_attack_on_input()

#region User input actions.
func _attack_on_input():
	if Input.is_action_just_pressed("attack"):
		attack_timer.start()
		_charging = true
	elif Input.is_action_just_released("attack"): 
		attack_released.emit(attack_timer.wait_time - attack_timer.time_left) # Include time elapsed
		attack_timer.stop()
		_charging = false
	elif Input.is_action_just_pressed("absorb") and _charging:
		attack_canceled.emit() 
		attack_timer.stop()
		_charging = false

func _cycle_active_element_on_input():
	if Input.is_action_just_pressed("cycle_element_once"):
		_cycle_active_element(1)
		if active_element == Element.NONE:
			_cycle_active_element(1)
	if Input.is_action_just_pressed("cycle_element_twice"):
		_cycle_active_element(2)
		if active_element == Element.NONE or active_element == Element.FIRE: # NONE was passed over 
			_cycle_active_element(1)
#endregion


#region Elemental resource value manipulation and checking.
func _drain_resources(delta : float):
	var loss_rate = -1
	update_elemental_resource(Element.FIRE, loss_rate * delta)
	update_elemental_resource(Element.WATER, loss_rate * delta)
	update_elemental_resource(Element.EARTH, loss_rate * delta)
	update_elemental_resource(Element.AIR, loss_rate * delta)

# Function to cycle the active element by the given amount (e.g. FIRE + 1 = WATER)
func _cycle_active_element(cycle_amount : int):
	active_element += cycle_amount
	active_element %= Element.AIR + 1 # Final element 

# Function to update elemental resources
func update_elemental_resource(element: Element, amount: float):
	elemental_resources[element] += amount
	elemental_resources[element] = clamp(elemental_resources[element], 0.0, elemental_resource_maxes[element]) # Adjust the range as needed
	_update_hud()

func get_element_name_from_value(element : Element) -> String:
	match element:
		Element.FIRE: return "Fire"
		Element.WATER: return "Water"
		Element.EARTH: return "Earth"
		Element.AIR: return "Air"
		_: return ""

#endregion 

# Function to update the HUD's TextureProgressBars
func _update_hud():
	for element in Element.values():
		if hud:
			var elementName = get_element_name_from_value(element)
			if elementName != "":
				var progressBar : TextureProgressBar = hud.get_node(elementName + "ResourceBar")
				if progressBar:
					progressBar.value = elemental_resources[element]
					progressBar.max_value = elemental_resource_maxes[element]

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta * 10)

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
