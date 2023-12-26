extends Area2D

@export var boost = 1.5;
@export var duration = 2.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	queue_free()
	print("powerup despawned")


func _on_area_entered(area):
	if area.is_in_group("Player"):
		area.set_timed_speed_mult(boost, duration);
		queue_free()
		print("powerup collided with player")
