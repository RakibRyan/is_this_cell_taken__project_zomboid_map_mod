extends RichTextLabel
@onready var mod_maps_node = $"../../../mod maps"
var list_map_list = ""
# Called when the node enters the scene tree for the first time.
func split_array_to_lines(arr: Array) -> String:
	for element in arr:
		list_map_list += str(element) + "\n"
	return list_map_list

func _ready():
	split_array_to_lines(mod_maps_node.map_list)
	self.text = list_map_list
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_button_toggled(toggled_on):
	
	if self.visible == true:
		self.visible = false
	else:
		self.visible = true
		pass
	pass # Replace with function body.



