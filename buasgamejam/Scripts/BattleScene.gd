extends Node2D

var building_scene = preload("res://Scenes/building.tscn")
var removing_scene = preload("res://Scenes/remove_sprite.tscn")

var selected_object :CollisionObject2D
@onready var occupied_coordinates := [$HeartStatic.position]

var planning := true

enum {ADDING, DELETING}
var current_mode := ADDING

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selected_object = building_scene.instantiate()
	add_child(selected_object)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$MousePoint.position = get_local_mouse_position()
	if planning and $BuildableArea.overlaps_body($MousePoint):
		var mouseX = get_local_mouse_position().x
		var mouseY = get_local_mouse_position().y
		var newPos = Vector2(snapped(mouseX, 32), snapped(mouseY, 32))
		match current_mode:
			ADDING:
				if newPos not in occupied_coordinates:
					selected_object.position = newPos
				if Input.is_action_just_pressed("confirm"):
					selected_object.collision_layer = 1
					occupied_coordinates.append(selected_object.position)
					selected_object.add_to_group("buildings")
					selected_object = building_scene.instantiate()
					add_child(selected_object)
			DELETING:
				selected_object.position = newPos
				if Input.is_action_just_pressed("confirm"):
					var overlapping = (selected_object as Area2D).get_overlapping_bodies()
					if not overlapping.is_empty():
						var chosen = overlapping[0] as Building
						if chosen && chosen.name != $HeartStatic.name:
							chosen.queue_free()


func _on_wall_button_pressed() -> void:
	selected_object.queue_free()
	selected_object = building_scene.instantiate()
	add_child(selected_object)
	current_mode = ADDING


func _on_remove_button_pressed() -> void:
	selected_object.queue_free()
	selected_object = removing_scene.instantiate()
	add_child(selected_object)
	current_mode = DELETING


func _on_play_button_pressed() -> void:
	selected_object.queue_free()
	planning = false
