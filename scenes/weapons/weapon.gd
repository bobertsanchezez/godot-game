extends AnimatedSprite2D
class_name Weapon2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called on current weapon when player receives attack input. Does not always trigger an attack.
func attack(element : Player.Element):
	pass # Replace with weapon-specific attack.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
