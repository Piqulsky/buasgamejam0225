extends StaticBody2D

class_name Building

# Parent variables
var life := 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hit() -> void:
	life -= 1
	if life == 0:
		queue_free()
