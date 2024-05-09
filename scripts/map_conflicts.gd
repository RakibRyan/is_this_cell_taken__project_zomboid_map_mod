extends RichTextLabel
@onready var world_map = $"../../.."



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if world_map.extracted_names.size() == 0:
		self.text = "No moddded Maps"
	else:
		self.text = str(world_map.extracted_names)
	pass
