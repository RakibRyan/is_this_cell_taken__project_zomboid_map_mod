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
		#var first_element = world_map.extracted_names[0]
		## Get the rest of the elements and join them with "|" separator
		#var rest_elements = "|".join(world_map.extracted_names.slice(1, world_map.extracted_names.size()))
		## Construct the text string
		#var text = "[color=ffffff]%s[/color]" % first_element
		## If there are more elements, add the separator after the first element
		#if rest_elements != "":
			#text += "|[color=red]%s[/color]" % rest_elements
		#self.text = text # Assign the text to self.text
		self.text = str(world_map.extracted_names)
