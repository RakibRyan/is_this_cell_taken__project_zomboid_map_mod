extends RichTextLabel

@onready var mod_maps = $"../../../mod maps"
var version_no = "2.02.03"  # First no major feature upgrade, 2nd tool upgrade, 3rd iteration

# Called when the node enters the scene tree for the first time.
func _ready():
	# Assuming mod_maps contains a variable total_no_of_maps
	var total_no_of_maps = mod_maps.total_no_of_maps
	
	# Construct the text to display
	self.text = "Ver: " + str(version_no) + " Maps: " + str(total_no_of_maps)
	pass
