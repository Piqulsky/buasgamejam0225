extends Area2D

class_name Bullet

const SPEED = 300
var target :Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target and target != null:
		var newX = move_toward(position.x, target.position.x, delta * SPEED)
		var newY = move_toward(position.y, target.position.y, delta * SPEED)
		position = Vector2(newX, newY)
		if overlaps_body(target):
			target.hit()
			target = null
