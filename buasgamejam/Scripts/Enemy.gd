extends CharacterBody2D


const SPEED = 100.0
var target :Vector2
var bounceVector :Vector2

func _ready() -> void:
	var heart := $"../HeartStatic"
	target = heart.position


func _physics_process(delta: float) -> void:
	if target:
		var direction = position.direction_to(target) + bounceVector
		bounceVector = Vector2(move_toward(bounceVector.x, 0, delta), move_toward(bounceVector.y, 0, delta))
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.x = move_toward(velocity.y, 0, SPEED)

	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var collidedBuilding := collision_info.get_collider() as Building
		if collidedBuilding.is_in_group("buildings"):
			collidedBuilding.hit()
			bounceVector = collision_info.get_normal() * 2
