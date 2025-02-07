extends Node2D

class_name BattleScene

var removing_scene = preload("res://Scenes/remove_sprite.tscn")
var enemy_scene = preload("res://Scenes/enemy.tscn")

var buildings := {
	"Building": preload("res://Scenes/building.tscn"),
	"Wall": preload("res://Scenes/wall.tscn"),
	"Turret": preload("res://Scenes/turret.tscn")
}

@onready var mouse_point := $MousePoint
@onready var buildable_area := $BuildableArea

var selected_object :CollisionObject2D
@onready var occupied_coordinates := [$HeartStatic.position]

var planning := true

enum {ADDING, DELETING, EMPTY}
var current_mode := EMPTY
var current_building_key := "Building"
var current_button :TextureButton

var buildingsLeft := {
	"Building": 100,
	"Wall": 120,
	"Turret": 20
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for key in buildingsLeft.keys():
		var buildButton = get_node("BattleHUD/PlanningButtonsPanel/" + key + "Button") as TextureButton
		buildButton.pressed.connect(_on_building_button_pressed.bind(key))
		var buttonText = buildButton.get_child(0) as Label
		buttonText.text = str(buildingsLeft[key])


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
					if buildingsLeft[current_building_key] > 0:
						selected_object = buildings[current_building_key].instantiate()
						add_child(selected_object)
					else:
						current_mode = EMPTY
			DELETING:
				selected_object.position = newPos
				if Input.is_action_just_pressed("confirm"):
					var overlapping = (selected_object as Area2D).get_overlapping_bodies()
					if not overlapping.is_empty():
						var chosen = overlapping[0] as Building
						if chosen && chosen.name != $HeartStatic.name:
							var script_name = str(chosen.get_script().get_path()).erase(0, 14).get_slice(".", 0)
							buildingsLeft[script_name] += 1
							get_node("BattleHUD/PlanningButtonsPanel/" + script_name + "Button").get_child(0).text = str(buildingsLeft[script_name])
							chosen.queue_free()
							


func _on_building_button_pressed(key: String) -> void:
	current_building_key = key
	current_button = get_node("BattleHUD/PlanningButtonsPanel/" + key + "Button") as TextureButton
	if selected_object and current_mode != EMPTY:
		selected_object.queue_free()
	selected_object = buildings[current_building_key].instantiate()
	add_child(selected_object)
	current_mode = ADDING

func _on_remove_button_pressed() -> void:
	if selected_object:
		selected_object.queue_free()
	selected_object = removing_scene.instantiate()
	add_child(selected_object)
	current_mode = DELETING


func _on_play_button_pressed() -> void:
	$BattleHUD/PlanningButtonsPanel.visible = false
	$BattleHUD/ScoreTimer.start()
	$SpawnPath/SpawnTimer.start()
	if current_mode != EMPTY:
		selected_object.queue_free()
	planning = false


func _on_spawn_timer_timeout() -> void:
	var follow = $SpawnPath/SpawnFollow as PathFollow2D
	follow.progress_ratio = randf()
	var enemy = enemy_scene.instantiate() as Node2D
	enemy.position = follow.position
	add_child(enemy)
