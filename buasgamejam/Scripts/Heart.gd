extends Building

class_name Heart

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	life = 10
	
func hit() -> void:
	super.hit()
	if life == 0:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
