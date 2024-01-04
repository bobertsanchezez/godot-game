extends Area2D
class_name AttractorField

@onready var _player : Player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	pass
	


func _on_body_exited(body):
	pass # Replace with function body.
