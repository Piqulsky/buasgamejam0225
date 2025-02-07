extends Control

var score_scene = preload("res://Scenes/score_panel.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var arr = Globals.times.keys().map(func (key): return [Globals.times[key], key])
	arr.sort()
	arr.reverse()
	for t in arr:
		var score = score_scene.instantiate()
		score.get_child(0).get_child(0).text = t[1]
		var time = t[0]
		var minutes = floor(time / 6000)
		var m_zero = "" if minutes >= 10 else "0"
		var seconds = floor((time % 6000) / 100)
		var s_zero = "" if seconds >= 10 else "0"
		var miliseconds = time % 100
		var l_zero = "" if miliseconds >= 10 else "0"
		score.get_child(0).get_child(1).text = "%s%d:%s%d:%s%d" % [m_zero, minutes, s_zero, seconds, l_zero, miliseconds]
		$Container.add_child(score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
