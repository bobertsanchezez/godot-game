extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$PinJoint2D.node_b = $RigidBody2D.get_path()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
