@tool
extends EditorPlugin


var dock


func _enter_tree() -> void:
	dock = preload("res://addons/project_time_tracker/project_timer.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, dock)


func _exit_tree() -> void:
	remove_control_from_docks(dock)
	dock.free()
