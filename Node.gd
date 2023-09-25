extends Node


func _ready():
	var map_data_resource = "res://map_data.txt"
	var map_data_file = FileAccess.open(map_data_resource,FileAccess.READ_WRITE)
	var map_data = map_data_file.get_as_text()
	print(map_data)
	pass

