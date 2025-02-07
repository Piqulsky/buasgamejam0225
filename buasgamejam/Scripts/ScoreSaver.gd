extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var time = Globals.current_time
	var minutes = floor(time / 6000)
	var m_zero = "" if minutes >= 10 else "0"
	var seconds = floor((time % 6000) / 100)
	var s_zero = "" if seconds >= 10 else "0"
	var miliseconds = time % 100
	var l_zero = "" if miliseconds >= 10 else "0"
	$Label.text = "%s%d:%s%d:%s%d" % [m_zero, minutes, s_zero, seconds, l_zero, miliseconds]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	if len($TextEdit.text) != 0:
		Globals.times[$TextEdit.text] = Globals.current_time
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_text_edit_text_changed(new_text: String) -> void:
	var textEdit = $TextEdit as LineEdit
	if textEdit.text[-1] != ".":
		textEdit.insert_text_at_caret(".")
