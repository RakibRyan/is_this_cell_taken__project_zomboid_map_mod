extends Node

var map_folder = "res://maps/"
var all_maps = []

func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				all_maps.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	

func map_name():
	
	pass

# Function to open a text file, extract map_name, and create a node
func createNodeFromTextFile(fileName: String):
	# Open the text file
	var file = FileAccess.open("res://maps/test.txt", FileAccess.READ_WRITE) 

		# Read the content of the file
	var fileContent = file.get_as_text()
#		file.close()
	if (fileContent != null ):
		# Find the position of "map_name ="
		var mapNameIndex = fileContent.find("map_name =")
		if mapNameIndex != -1:
			# Find the first occurrence of double quotes after "map_name ="
			var quoteIndex = fileContent.find('"', mapNameIndex)
			if quoteIndex != -1:
				var endIndex = fileContent.find('"', quoteIndex + 1)
				if endIndex != -1:
					# Extract the map name from between double quotes
					var mapName = fileContent.substr(quoteIndex + 1, endIndex - quoteIndex - 1)

					# Create a new Node with the extracted name
					var newNode = Node.new()
					newNode.name = mapName
					print(mapName)
			
					# Add the node to the scene or wherever you need it
					# For example, adding it to the current scene
					get_tree().get_root().add_child(newNode)
				else:
					print("No closing double quote found after map_name.")
			else:
				print("No double quotes found after map_name.")
		else:
			print("map_name not found in the file.")
	else:
		print("Failed to open the file: ", fileName)




func _ready():
	dir_contents(map_folder)
	print(all_maps)
#	processTxtFiles(all_maps)
	createNodeFromTextFile("test.txt")
#	print_tree()
	pass
	# Replace 'path/to/your/folder' with the actual path to your folder containing text files.



# Called every frame. 'delta' is the elapsed time since the previous frame.

