extends Area2D
class_name AttractorField

@onready var _player : Player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready():
	disable_collision()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	pass
	


func _on_body_exited(body):
	pass # Replace with function body.

func disable_collision():
	collision_mask = 0
	set_deferred("disabled", true)
	#$CollisionPolygon2D.set_deferred("disabled", true)
	pass
func enable_collision():
	collision_mask = 4
	set_deferred("disabled", false)
	#$CollisionPolygon2D.set_deferred("disabled", false)
	pass
