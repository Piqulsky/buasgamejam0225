extends Control

class_name BattleHUD

var time := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_score_timer_timeout() -> void:
	time += 5
	var minutes = floor(time / 6000)
	var m_zero = "" if minutes >= 10 else "0"
	var seconds = floor((time % 6000) / 100)
	var s_zero = "" if seconds >= 10 else "0"
	var miliseconds = time % 100
	var l_zero = "" if miliseconds >= 10 else "0"
	$Score.text = "%s%d:%s%d:%s%d" % [m_zero, minutes, s_zero, seconds, l_zero, miliseconds]
