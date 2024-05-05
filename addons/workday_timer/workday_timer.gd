@tool
extends EditorPlugin

const TimerScene := preload("res://addons/workday_timer/workday_timer.tscn")
var timer: Node
var container := 0


func _enter_tree():
	timer = TimerScene.instantiate()
	timer.name = "addon_countdown"
	add_control_to_container(container, timer)
	
	
func _exit_tree():
	remove_control_from_container(container, timer)
	timer.queue_free()
