extends RigidBody2D

class_name Shard

@export var fire_shard_sprite : Texture2D
@export var water_shard_sprite : Texture2D
@export var earth_shard_sprite : Texture2D
@export var air_shard_sprite : Texture2D

var thrown := false
var reset_transform : Transform2D
var elemental_type : Player.Element = Player.Element.NONE

@onready var _sprite : Sprite2D = $Smoothing2D/Sprite2D
@onready var _player : Player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready():
	match elemental_type:
		Player.Element.NONE: _sprite.texture = fire_shard_sprite
		Player.Element.FIRE: _sprite.texture = fire_shard_sprite 
		Player.Element.WATER: _sprite.texture = water_shard_sprite 
		Player.Element.EARTH: _sprite.texture = earth_shard_sprite 
		Player.Element.AIR: _sprite.texture = air_shard_sprite 
	$Smoothing2D/Sprite2D.visible = false

func _integrate_forces(state):
	# Rotate towards mouse position
	if !thrown:
		var rotation_weight := .1
		var target_angle = position.angle_to_point(get_global_mouse_position())
		state.transform = Transform2D(lerp_angle(rotation, target_angle, rotation_weight), position)
	else:
		var rotation_weight := .04
		var target_angle = linear_velocity.angle()
		state.transform = Transform2D(lerp_angle(rotation, target_angle, rotation_weight), position)

# Throw the shard when released
func on_release(charge_time : float):
	thrown = true
	var impulse_strength = 100.0 * mass * charge_time + 200.0
	var impulse_dir = Vector2(1, 0).rotated(rotation)
	# Also set shard's velocity to 0 
	var negate_vel_impulse = linear_velocity * mass * -1
	apply_central_impulse(impulse_dir * impulse_strength + negate_vel_impulse)

func on_cancel():
	queue_free()

func _on_body_entered(body):
	pass
	#queue_free()

# Call after instantiation but before adding this shard as a child of the tree to set elemental type
func setup(_elemental_type : Player.Element):
	self.elemental_type = _elemental_type


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_smoothing_timer_timeout():
	$Smoothing2D/Sprite2D.visible = true
