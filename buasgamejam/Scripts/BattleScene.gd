extends Node2D

var building_scene = preload("res://Scenes/building.tscn")
var removing_scene = preload("res://Scenes/remove_sprite.tscn")

@onready var mouse_point := $MousePoint
@onready var buildable_area := $BuildableArea

var selected_object :CollisionObject2D
@onready var occupied_coordinates := [$HeartStatic.position]

var planning := true

enum {ADDING, DELETING}
var current_mode := ADDING
var current_building_key := "Building"
var current_button :TextureButton

var buildingsLeft := {
	"Building": 15,
	"Wall": 5,
	"Turret": 2
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selected_object = building_scene.instantiate()
	add_child(selected_object)
	for key in buildingsLeft.keys():
		var button = get_node("BattleHUD/PlanningButtonsPanel/" + key + "Button") as TextureButton
		button.pressed.connect(_on_building_button_pressed.bind("key", key))
		var buttonText = button.get_child(0) as Label
		buttonText.text = str(buildingsLeft[key])
	current_button = get_node("BattleHUD/PlanningButtonsPanel/" + current_building_key + "Button") as TextureButton


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mouse_point.position = get_local_mouse_position()
	if planning and buildable_area.overlaps_body(mouse_point):
		var mouseX = get_local_mouse_position().x
		var mouseY = get_local_mouse_position().y
		var newPos = Vector2(snapped(mouseX, 32), snapped(mouseY, 32))
		match current_mode:
			ADDING:
				if newPos not in occupied_coordinates:
					selected_object.position = newPos
				if Input.is_action_just_pressed("confirm"):
					buildingsLeft[current_building_key] -= 1
					(current_button.get_child(0) as Label).text = str(buildingsLeft[current_building_key])
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


func _on_building_button_pressed(key: String) -> void:
	current_building_key = key
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
