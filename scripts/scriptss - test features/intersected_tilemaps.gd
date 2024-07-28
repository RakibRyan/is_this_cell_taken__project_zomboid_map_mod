extends Node2D


var test_arr = [1,2,3,4,5,6,7]
var number

func test(numbers_array:Array):
	numbers_array.append(8)
	print(test_arr)
	numbers_array.append(9)
	print(test_arr)
	numbers_array.insert(5, 55)
	numbers_array.insert(7,77)
func _ready():
	#testing = get_cell_atlas_coords(0, Vector2i(27,20)) 
	test(test_arr)
	print(test_arr)
	pass
