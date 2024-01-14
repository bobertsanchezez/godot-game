extends Area2D
class_name HitboxComponent

@export var HealthComponent : HealthComponent

func damage(attack: Attack):
#first check if health component exists
	if HealthComponent:
		HealthComponent.damage(attack)


