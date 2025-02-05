extends Building

class_name Turret

var bullet_scene = preload("res://Scenes/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	life = 3


func _on_shoot_timer_timeout() -> void:
	for o in $RangeArea.get_overlapping_bodies():
		var target = o as Enemy
		if target:
			shoot_target(target)

func shoot_target(target :Enemy):
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.target = target
	add_child(bullet)
